//
//  PriceTrackerViewModel.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import Foundation
import SwiftUI

class PriceTrackerViewModel: ObservableObject {

    @Published var stocks: [StockItem] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var isFeedActive: Bool = false
    @Published var flashSymbols: Set<String> = []

    init() {
        loadInitialStocks()
    }

    // populate list with random base prices, sorted highest first
    private func loadInitialStocks() {
        stocks = StockCatalog.initialStocks().sorted { $0.price > $1.price }
    }

    func toggleFeed() {
        isFeedActive.toggle()
        // TODO: wire up WebSocket connect/disconnect here
    }

    func stock(for symbol: String) -> StockItem? {
        stocks.first { $0.id == symbol }
    }
}
