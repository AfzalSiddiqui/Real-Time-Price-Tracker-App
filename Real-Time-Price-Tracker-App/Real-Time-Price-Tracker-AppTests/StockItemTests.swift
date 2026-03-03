//
//  StockItemTests.swift
//  Real-Time-Price-Tracker-AppTests
//
//  Created by Afzal on 03/03/2026.
//

import Testing
import Foundation
@testable import Real_Time_Price_Tracker_App

struct StockItemTests {

    @Test func initSetsCorrectValues() {
        let stock = StockItem(id: "AAPL", name: "Apple", description: "Tech company", price: 150.0, previousPrice: 140.0)

        #expect(stock.id == "AAPL")
        #expect(stock.name == "Apple")
        #expect(stock.price == 150.0)
        #expect(stock.previousPrice == 140.0)
    }

    @Test func priceGoingUp() {
        let stock = StockItem(id: "AAPL", name: "Apple", description: "", price: 160.0, previousPrice: 150.0)
        #expect(stock.priceDirection == .up)
    }

    @Test func priceGoingDown() {
        let stock = StockItem(id: "TSLA", name: "Tesla", description: "", price: 100.0, previousPrice: 200.0)
        #expect(stock.priceDirection == .down)
    }

    @Test func priceNotChanged() {
        let stock = StockItem(id: "GOOG", name: "Google", description: "", price: 300.0, previousPrice: 300.0)
        #expect(stock.priceDirection == .unchanged)
    }

    @Test func catalogReturns25() {
        #expect(StockCatalog.initialStocks().count == 25)
    }

    @Test func noDuplicateSymbols() {
        let stocks = StockCatalog.initialStocks()
        let ids = Set(stocks.map { $0.id })
        #expect(ids.count == stocks.count)
    }

    // fresh stocks should have no direction since price == previousPrice
    @Test func freshStocksAreUnchanged() {
        for stock in StockCatalog.initialStocks() {
            #expect(stock.priceDirection == .unchanged)
        }
    }

    @Test func priceUpdateRoundTrip() throws {
        let update = PriceUpdate(symbol: "NVDA", price: 425.50, timestamp: Date())

        let data = try JSONEncoder().encode(update)
        let decoded = try JSONDecoder().decode(PriceUpdate.self, from: data)

        #expect(decoded.symbol == "NVDA")
        #expect(decoded.price == 425.50)
    }

    @Test func batchEncoding() throws {
        let batch = [
            PriceUpdate(symbol: "AAPL", price: 150.0, timestamp: Date()),
            PriceUpdate(symbol: "GOOG", price: 280.0, timestamp: Date())
        ]

        let encoded = try JSONEncoder().encode(batch)
        let decoded = try JSONDecoder().decode([PriceUpdate].self, from: encoded)

        #expect(decoded.count == 2)
        #expect(decoded[0].symbol == "AAPL")
    }
}
