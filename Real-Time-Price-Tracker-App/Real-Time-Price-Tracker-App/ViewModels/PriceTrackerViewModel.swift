//
//  PriceTrackerViewModel.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import Foundation
import Combine
import SwiftUI

class PriceTrackerViewModel: ObservableObject {

    @Published var stocks: [StockItem] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var isFeedActive = false
    @Published var highlightedSymbols: Set<String> = []
    @Published var navPath = NavigationPath()

    private let feedService: any PriceFeedProvider
    private var subs = Set<AnyCancellable>()
    private var flashSub: AnyCancellable?

    init(feedService: any PriceFeedProvider = WebSocketService()) {
        self.feedService = feedService
        setupStocks()
        setupBindings()
    }

    private func setupStocks() {
        stocks = StockCatalog.initialStocks().sorted { $0.price > $1.price }
    }

    // MARK: - Combine

    private func setupBindings() {
        feedService.statusPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionStatus)

        feedService.pricePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in self?.handlePriceData(data) }
            .store(in: &subs)
    }

    private func handlePriceData(_ incoming: [PriceUpdate]) {
        guard !incoming.isEmpty else { return }

        var list = stocks
        var changed = Set<String>()
        let indexMap = Dictionary(uniqueKeysWithValues: list.indices.map { (list[$0].id, $0) })

        for update in incoming {
            guard let i = indexMap[update.symbol] else { continue }
            let old = list[i].price
            list[i].previousPrice = old
            list[i].price = update.price
            if old != update.price { changed.insert(update.symbol) }
        }

        list.sort { $0.price > $1.price }
        stocks = list
        flashSub?.cancel()
        highlightedSymbols = changed

        flashSub = Just(())
            .delay(for: .seconds(Constants.Animation.flashDuration), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in self?.highlightedSymbols = [] }
    }

    func toggleFeed() {
        isFeedActive ? feedService.disconnect() : feedService.connect()
        isFeedActive.toggle()
    }

    func stock(for symbol: String) -> StockItem? {
        stocks.first { $0.id == symbol }
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
