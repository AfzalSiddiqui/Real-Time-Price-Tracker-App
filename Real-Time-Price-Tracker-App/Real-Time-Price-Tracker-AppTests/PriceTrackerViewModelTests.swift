//
//  PriceTrackerViewModelTests.swift
//  Real-Time-Price-Tracker-AppTests
//
//  Created by Afzal on 03/03/2026.
//

import Testing
import Foundation
@testable import Real_Time_Price_Tracker_App

@MainActor
struct PriceTrackerViewModelTests {

    private func makeSUT() -> (vm: PriceTrackerViewModel, mock: MockPriceFeedService) {
        let mock = MockPriceFeedService()
        let vm = PriceTrackerViewModel(feedService: mock)
        return (vm, mock)
    }

    // MARK: - Initial State

    @Test func loadsAllStocks() {
        let (vm, _) = makeSUT()
        #expect(vm.stocks.count == 25)
    }

    @Test func stocksAreSortedByPrice() {
        let (vm, _) = makeSUT()
        for i in 0..<(vm.stocks.count - 1) {
            #expect(vm.stocks[i].price >= vm.stocks[i + 1].price)
        }
    }

    @Test func startsDisconnected() {
        let (vm, _) = makeSUT()
        #expect(vm.connectionStatus == .disconnected)
        #expect(vm.isFeedActive == false)
    }

    @Test func findStockBySymbol() {
        let (vm, _) = makeSUT()
        let apple = vm.stock(for: "AAPL")
        #expect(apple != nil)
        #expect(apple?.id == "AAPL")
    }

    @Test func returnsNilForBadSymbol() {
        let (vm, _) = makeSUT()
        #expect(vm.stock(for: "FAKE") == nil)
    }

    @Test func noHighlightsInitially() {
        let (vm, _) = makeSUT()
        #expect(vm.highlightedSymbols.isEmpty)
    }

    // MARK: - Deep Link

    @Test func deepLinkPushesNav() {
        let (vm, _) = makeSUT()
        vm.handleDeepLink(URL(string: "stocks://symbol/AAPL")!)
        #expect(vm.navPath.count == 1)
    }

    @Test func deepLinkIgnoresBadInput() {
        let (vm, _) = makeSUT()

        // wrong scheme
        vm.handleDeepLink(URL(string: "https://symbol/AAPL")!)
        #expect(vm.navPath.isEmpty)

        // unknown ticker
        vm.handleDeepLink(URL(string: "stocks://symbol/ZZZZ")!)
        #expect(vm.navPath.isEmpty)
    }

    // MARK: - Connection Sync

    @Test func toggleCallsConnectOnService() async throws {
        let (vm, mock) = makeSUT()
        #expect(vm.isFeedActive == false)

        vm.toggleFeed()
        #expect(mock.connectCallCount == 1)
    }

    @Test func connectionStatusSyncsIsFeedActive() async throws {
        let (vm, mock) = makeSUT()

        mock.simulateConnected()
        try await Task.sleep(for: .milliseconds(50))
        #expect(vm.connectionStatus == .connected)
        #expect(vm.isFeedActive == true)

        mock.simulateStatus(.disconnected)
        try await Task.sleep(for: .milliseconds(50))
        #expect(vm.connectionStatus == .disconnected)
        #expect(vm.isFeedActive == false)
    }

    // MARK: - Price Update Flow

    @Test func priceUpdateFlowUpdatesStock() async throws {
        let (vm, mock) = makeSUT()
        let apple = vm.stock(for: "AAPL")!
        let newPrice = apple.price + 50

        mock.simulatePrices([PriceUpdate(symbol: "AAPL", price: newPrice, timestamp: Date())])
        try await Task.sleep(for: .milliseconds(50))

        let updated = vm.stock(for: "AAPL")!
        #expect(updated.price == newPrice)
        #expect(updated.previousPrice == apple.price)
    }

    @Test func priceUpdateHighlightsChangedSymbol() async throws {
        let (vm, mock) = makeSUT()
        let apple = vm.stock(for: "AAPL")!

        mock.simulatePrices([PriceUpdate(symbol: "AAPL", price: apple.price + 10, timestamp: Date())])
        try await Task.sleep(for: .milliseconds(50))

        #expect(vm.highlightedSymbols.contains("AAPL"))
    }

    @Test func priceUpdateResortsList() async throws {
        let (vm, mock) = makeSUT()

        // Give the last stock a very high price to force re-sort
        let lastStock = vm.stocks.last!
        mock.simulatePrices([PriceUpdate(symbol: lastStock.id, price: 99999, timestamp: Date())])
        try await Task.sleep(for: .milliseconds(50))

        #expect(vm.stocks.first?.id == lastStock.id)
    }

    @Test func emptyUpdateDoesNothing() async throws {
        let (vm, mock) = makeSUT()
        let originalStocks = vm.stocks

        mock.simulatePrices([])
        try await Task.sleep(for: .milliseconds(50))

        #expect(vm.stocks == originalStocks)
        #expect(vm.highlightedSymbols.isEmpty)
    }

    @Test func samePriceDoesNotHighlight() async throws {
        let (vm, mock) = makeSUT()
        let apple = vm.stock(for: "AAPL")!

        // Send same price — should not trigger highlight
        mock.simulatePrices([PriceUpdate(symbol: "AAPL", price: apple.price, timestamp: Date())])
        try await Task.sleep(for: .milliseconds(50))

        #expect(!vm.highlightedSymbols.contains("AAPL"))
    }
}
