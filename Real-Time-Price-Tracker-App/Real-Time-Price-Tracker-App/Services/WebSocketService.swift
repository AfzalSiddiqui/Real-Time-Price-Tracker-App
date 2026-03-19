//
//  WebSocketService.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import Foundation

final class WebSocketService: PriceFeedProvider, @unchecked Sendable {

    let statusStream: AsyncStream<ConnectionStatus>
    let priceStream: AsyncStream<[PriceUpdate]>

    private(set) var currentStatus: ConnectionStatus = .disconnected

    private let statusContinuation: AsyncStream<ConnectionStatus>.Continuation
    private let priceContinuation: AsyncStream<[PriceUpdate]>.Continuation

    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession?
    private var feedLoop: Task<Void, Never>?
    private let tickers: [String]
    private var cachedPrices: [String: Double] = [:]

    init(tickers: [String] = StockCatalog.symbols.map { $0.symbol }) {
        self.tickers = tickers

        let (statusStream, statusContinuation) = AsyncStream.makeStream(of: ConnectionStatus.self)
        self.statusStream = statusStream
        self.statusContinuation = statusContinuation

        let (priceStream, priceContinuation) = AsyncStream.makeStream(of: [PriceUpdate].self)
        self.priceStream = priceStream
        self.priceContinuation = priceContinuation
    }

    deinit {
        feedLoop?.cancel()
        statusContinuation.finish()
        priceContinuation.finish()
    }

    func connect() {
        guard let url = URL(string: Constants.WebSocket.serverURL) else { return }

        disconnect()

        let session = URLSession(configuration: .default)
        let task = session.webSocketTask(with: url)
        task.resume()

        self.session = session
        self.webSocketTask = task
        setStatus(.connecting)

        feedLoop = Task { [weak self] in
            guard let self else { return }

            do {
                // first successful round-trip confirms connection
                let batch = self.generatePrices()
                try await self.send(batch, on: task)
                let echo = try await self.receive(from: task)

                self.setStatus(.connected)
                self.priceContinuation.yield(echo)

                // steady-state loop
                while !Task.isCancelled {
                    try await Task.sleep(for: .seconds(Constants.WebSocket.sendInterval))
                    let prices = self.generatePrices()
                    try await self.send(prices, on: task)
                    let received = try await self.receive(from: task)
                    self.priceContinuation.yield(received)
                }
            } catch {
                if !Task.isCancelled {
                    self.setStatus(.disconnected)
                }
            }
        }
    }

    func disconnect() {
        feedLoop?.cancel()
        feedLoop = nil
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        session?.invalidateAndCancel()
        session = nil
        setStatus(.disconnected)
    }

    // MARK: - Private

    private func setStatus(_ status: ConnectionStatus) {
        currentStatus = status
        statusContinuation.yield(status)
    }

    private func generatePrices() -> [PriceUpdate] {
        tickers.map { ticker in
            let prev = cachedPrices[ticker] ?? Double.random(in: 50...400)
            let next = (prev * Double.random(in: Constants.WebSocket.fluctuation) * 100).rounded() / 100
            cachedPrices[ticker] = next
            return PriceUpdate(symbol: ticker, price: next, timestamp: Date())
        }
    }

    private func send(_ batch: [PriceUpdate], on task: URLSessionWebSocketTask) async throws {
        let data = try JSONEncoder().encode(batch)
        guard let json = String(data: data, encoding: .utf8) else { return }
        try await task.send(.string(json))
    }

    private func receive(from task: URLSessionWebSocketTask) async throws -> [PriceUpdate] {
        let message = try await task.receive()
        guard case .string(let raw) = message,
              let data = raw.data(using: .utf8) else { return [] }
        return try JSONDecoder().decode([PriceUpdate].self, from: data)
    }
}
