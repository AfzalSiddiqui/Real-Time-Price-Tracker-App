//
//  WebSocketServiceTests.swift
//  Real-Time-Price-Tracker-AppTests
//
//  Created by Afzal on 03/03/2026.
//

import Testing
@testable import Real_Time_Price_Tracker_App

struct WebSocketServiceTests {

    @Test func startsDisconnected() {
        let svc = WebSocketService()
        #expect(svc.currentStatus == .disconnected)
    }

    @Test func catalogHas25Tickers() {
        #expect(StockCatalog.symbols.count == 25)
    }

    @Test func canInitWithCustomTickers() {
        let svc = WebSocketService(tickers: ["AAPL", "GOOG"])
        #expect(svc.currentStatus == .disconnected)
    }
}
