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

    private let wsService: WebSocketService
    private var subs = Set<AnyCancellable>()
    private var flashWork: DispatchWorkItem?

    init(wsService: WebSocketService = WebSocketService()) {
        self.wsService = wsService
        setupStocks()
        setupBindings()
    }

    private func setupStocks() {
        stocks = StockCatalog.initialStocks().sorted { $0.price > $1.price }
    }

    // MARK: - Combine

    private func setupBindings() {
        wsService.$status
            .receive(on: DispatchQueue.main)
            .assign(to: &$connectionStatus)

        wsService.$priceUpdates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in self?.handlePriceData(data) }
            .store(in: &subs)
    }

    private func handlePriceData(_ incoming: [PriceUpdate]) {
        guard !incoming.isEmpty else { return }

        var list = stocks
        var changed = Set<String>()

        for update in incoming {
            guard let i = list.firstIndex(where: { $0.id == update.symbol }) else { continue }
            let old = list[i].price
            list[i].previousPrice = old
            list[i].price = update.price
            if old != update.price { changed.insert(update.symbol) }
        }

        list.sort { $0.price > $1.price }
        stocks = list
        // cancel previous flash timer if still running
        flashWork?.cancel()
        highlightedSymbols = changed

        let work = DispatchWorkItem { [weak self] in
            self?.highlightedSymbols = []
        }
        flashWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: work)
    }

    func toggleFeed() {
        isFeedActive ? wsService.disconnect() : wsService.connect()
        isFeedActive.toggle()
    }

    func stock(for symbol: String) -> StockItem? {
        stocks.first { $0.id == symbol }
    }

    // expected format: stocks://symbol/AAPL
    func handleDeepLink(_ url: URL) {
        guard url.scheme == "stocks",
              url.host == "symbol",
              let ticker = url.pathComponents.dropFirst().first,
              stock(for: ticker) != nil else { return }

        navPath = NavigationPath()
        navPath.append(ticker)
    }
}
