//
//  PriceFeedProvider.swift
//  Real-Time-Price-Tracker-App
//

import Foundation

enum ConnectionStatus: Equatable, Sendable {
    case connected, disconnected, connecting
}

struct PriceUpdate: Codable, Equatable, Sendable {
    let symbol: String
    let price: Double
    let timestamp: Date
}

protocol PriceFeedProvider: AnyObject, Sendable {
    var statusStream: AsyncStream<ConnectionStatus> { get }
    var priceStream: AsyncStream<[PriceUpdate]> { get }
    func connect()
    func disconnect()
}
