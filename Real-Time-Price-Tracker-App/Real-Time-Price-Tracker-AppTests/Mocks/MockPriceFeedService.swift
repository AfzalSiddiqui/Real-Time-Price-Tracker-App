//
//  MockPriceFeedService.swift
//  Real-Time-Price-Tracker-AppTests
//

import Foundation
@testable import Real_Time_Price_Tracker_App

final class MockPriceFeedService: PriceFeedProvider, @unchecked Sendable {

    let statusStream: AsyncStream<ConnectionStatus>
    let priceStream: AsyncStream<[PriceUpdate]>

    private let statusContinuation: AsyncStream<ConnectionStatus>.Continuation
    private let priceContinuation: AsyncStream<[PriceUpdate]>.Continuation

    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0

    init() {
        let (statusStream, statusContinuation) = AsyncStream.makeStream(of: ConnectionStatus.self)
        self.statusStream = statusStream
        self.statusContinuation = statusContinuation

        let (priceStream, priceContinuation) = AsyncStream.makeStream(of: [PriceUpdate].self)
        self.priceStream = priceStream
        self.priceContinuation = priceContinuation
    }

    func connect() {
        connectCallCount += 1
        statusContinuation.yield(.connecting)
    }

    func disconnect() {
        disconnectCallCount += 1
        statusContinuation.yield(.disconnected)
    }

    // MARK: - Test Helpers

    func simulateConnected() {
        statusContinuation.yield(.connected)
    }

    func simulateStatus(_ status: ConnectionStatus) {
        statusContinuation.yield(status)
    }

    func simulatePrices(_ updates: [PriceUpdate]) {
        priceContinuation.yield(updates)
    }
}
