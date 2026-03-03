//
//  WebSocketService.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import Foundation
import Combine

protocol PriceFeedProvider: AnyObject {
    var statusPublisher: AnyPublisher<ConnectionStatus, Never> { get }
    var pricePublisher: AnyPublisher<[PriceUpdate], Never> { get }
    func connect()
    func disconnect()
}

final class WebSocketService: NSObject, ObservableObject, @unchecked Sendable {

    @Published var status: ConnectionStatus = .disconnected
    @Published var priceUpdates: [PriceUpdate] = []

    private var socketTask: URLSessionWebSocketTask?
    private var session: URLSession!
    private var timerSub: AnyCancellable?
    private let tickers: [String]
    private var cachedPrices: [String: Double] = [:]

    private let serverURL = Constants.WebSocket.serverURL
    private let interval = Constants.WebSocket.sendInterval
    private let fluctuation = Constants.WebSocket.fluctuation

    init(tickers: [String] = StockCatalog.symbols.map { $0.symbol }) {
        self.tickers = tickers
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }

    func connect() {
        guard let url = URL(string: serverURL) else { return }
        status = .connecting
        socketTask = session.webSocketTask(with: url)
        socketTask?.resume()
    }

    func disconnect() {
        killTimer()
        socketTask?.cancel(with: .goingAway, reason: nil)
        socketTask = nil
        status = .disconnected
    }

    // MARK: - Timer

    private func kickoffTimer() {
        timerSub = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.sendPrices() }
    }

    private func killTimer() {
        timerSub?.cancel()
        timerSub = nil
    }

    // MARK: - WebSocket I/O

    private func sendPrices() {
        let batch = tickers.map { ticker -> PriceUpdate in
            let prev = cachedPrices[ticker] ?? Double.random(in: 50...400)
            let next = (prev * Double.random(in: fluctuation) * 100).rounded() / 100
            cachedPrices[ticker] = next
            return PriceUpdate(symbol: ticker, price: next, timestamp: Date())
        }

        guard let data = try? JSONEncoder().encode(batch),
              let payload = String(data: data, encoding: .utf8) else { return }

        // send to echo server, then listen for the bounce-back
        socketTask?.send(.string(payload)) { [weak self] err in
            if err == nil { self?.listenForEcho() }
        }
    }

    private func listenForEcho() {
        socketTask?.receive { [weak self] result in
            switch result {
            case .success(.string(let raw)):
                if let data = raw.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode([PriceUpdate].self, from: data) {
                    DispatchQueue.main.async { self?.priceUpdates = decoded }
                }
            case .failure:
                DispatchQueue.main.async { self?.status = .disconnected }
            default:
                break
            }
        }
    }
}

extension WebSocketService: PriceFeedProvider {
    var statusPublisher: AnyPublisher<ConnectionStatus, Never> {
        $status.eraseToAnyPublisher()
    }
    var pricePublisher: AnyPublisher<[PriceUpdate], Never> {
        $priceUpdates.eraseToAnyPublisher()
    }
}

// MARK: - Delegate

extension WebSocketService: URLSessionWebSocketDelegate {

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol proto: String?) {
        // print("WS connected")
        status = .connected
        kickoffTimer()
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith code: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        killTimer()
        status = .disconnected
    }
}
