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

    private func makeVM() -> PriceTrackerViewModel {
        PriceTrackerViewModel()
    }

    @Test func loadsAllStocks() {
        let vm = makeVM()
        #expect(vm.stocks.count == 25)
    }

    @Test func stocksAreSortedByPrice() {
        let vm = makeVM()
        for i in 0..<(vm.stocks.count - 1) {
            #expect(vm.stocks[i].price >= vm.stocks[i + 1].price)
        }
    }

    @Test func startsDisconnected() {
        let vm = makeVM()
        #expect(vm.connectionStatus == .disconnected)
        #expect(vm.isFeedActive == false)
    }

    @Test func findStockBySymbol() {
        let vm = makeVM()
        let apple = vm.stock(for: "AAPL")
        #expect(apple != nil)
        #expect(apple?.id == "AAPL")
    }

    @Test func returnsNilForBadSymbol() {
        let vm = makeVM()
        #expect(vm.stock(for: "FAKE") == nil)
    }

    @Test func toggleFlipsFlag() {
        let vm = makeVM()
        #expect(vm.isFeedActive == false)

        vm.toggleFeed()
        #expect(vm.isFeedActive == true)

        vm.toggleFeed()
        #expect(vm.isFeedActive == false)
    }

    // deep link should push onto nav path
    @Test func deepLinkPushesNav() {
        let vm = makeVM()
        vm.handleDeepLink(URL(string: "stocks://symbol/AAPL")!)
        #expect(vm.navPath.count == 1)
    }

    @Test func deepLinkIgnoresBadInput() {
        let vm = makeVM()

        // wrong scheme
        vm.handleDeepLink(URL(string: "https://symbol/AAPL")!)
        #expect(vm.navPath.isEmpty)

        // unknown ticker
        vm.handleDeepLink(URL(string: "stocks://symbol/ZZZZ")!)
        #expect(vm.navPath.isEmpty)
    }

    @Test func noHighlightsInitially() {
        #expect(makeVM().highlightedSymbols.isEmpty)
    }
}
