//
//  PriceTrackerViewModel.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import Foundation
import SwiftUI

@Observable
@MainActor
class PriceTrackerViewModel {

    var stocks: [StockItem] = []
    var connectionStatus: ConnectionStatus = .disconnected
    var isFeedActive = false
    var highlightedSymbols: Set<String> = []
    var navPath = NavigationPath()

    @ObservationIgnored private let feedService: any PriceFeedProvider
    @ObservationIgnored private var statusTask: Task<Void, Never>?
    @ObservationIgnored private var priceTask: Task<Void, Never>?
    @ObservationIgnored private var flashTask: Task<Void, Never>?
    @ObservationIgnored private var stockIndex: [String: Int] = [:]

    init(feedService: any PriceFeedProvider = WebSocketService()) {
        self.feedService = feedService
        stocks = StockCatalog.initialStocks().sorted { $0.price > $1.price }
        rebuildIndex()
        startObserving()
    }

    deinit {
        statusTask?.cancel()
        priceTask?.cancel()
        flashTask?.cancel()
    }

    // MARK: - Async Observation

    private func startObserving() {
        statusTask = Task { [weak self] in
            guard let stream = self?.feedService.statusStream else { return }
            for await status in stream {
                guard let self, !Task.isCancelled else { break }
                self.connectionStatus = status
                self.isFeedActive = (status == .connected)
            }
        }

        priceTask = Task { [weak self] in
            guard let stream = self?.feedService.priceStream else { return }
            for await prices in stream {
                guard let self, !Task.isCancelled else { break }
                self.handlePriceData(prices)
            }
        }
    }

    private func handlePriceData(_ incoming: [PriceUpdate]) {
        guard !incoming.isEmpty else { return }

        var list = stocks
        var changed = Set<String>()

        for update in incoming {
            guard let i = stockIndex[update.symbol],
                  list[i].price != update.price else { continue }
            list[i].previousPrice = list[i].price
            list[i].price = update.price
            changed.insert(update.symbol)
        }

        guard !changed.isEmpty else { return }

        let needsSort = !isSorted(list)
        if needsSort { list.sort { $0.price > $1.price } }
        stocks = list
        if needsSort { rebuildIndex() }

        flashTask?.cancel()
        highlightedSymbols = changed
        flashTask = Task {
            try? await Task.sleep(for: .seconds(Constants.Animation.flashDuration))
            guard !Task.isCancelled else { return }
            highlightedSymbols = []
        }
    }

    func toggleFeed() {
        isFeedActive ? feedService.disconnect() : feedService.connect()
    }

    func stock(for symbol: String) -> StockItem? {
        guard let i = stockIndex[symbol] else { return nil }
        return stocks[i]
    }

    private func isSorted(_ list: [StockItem]) -> Bool {
        for i in 1..<list.count where list[i - 1].price < list[i].price {
            return false
        }
        return true
    }

    private func rebuildIndex() {
        stockIndex = Dictionary(uniqueKeysWithValues: stocks.indices.map { (stocks[$0].id, $0) })
    }

    // expected format: stocks://symbol/AAPL
    func handleDeepLink(_ url: URL) {
        guard url.scheme == Constants.DeepLink.scheme,
              url.host == Constants.DeepLink.host,
              let ticker = url.pathComponents.dropFirst().first,
              stock(for: ticker) != nil else { return }

        navPath = NavigationPath()
        navPath.append(ticker)
    }
}
