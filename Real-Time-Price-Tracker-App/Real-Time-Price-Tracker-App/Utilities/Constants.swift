//
//  Constants.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import Foundation

// App-wide constants
enum Constants {

    enum App {
        static let title = "Price Tracker"
        static let subtitle = "Real-Time Stock Updates"
        static let currencyCode = "USD"
        static let splashDelay: TimeInterval = 2
    }

    enum WebSocket {
        static let serverURL = "wss://ws.postman-echo.com/raw"
        static let sendInterval: TimeInterval = 2.0
        static let fluctuation = 0.95...1.05
    }

    enum DeepLink {
        static let scheme = "stocks"
        static let host = "symbol"
    }

    enum Connection {
        static let startButton = "Start"
        static let stopButton = "Stop"
        static let connectedText = "Connected"
        static let disconnectedText = "Disconnected"
        static let connectingText = "Connecting..."
    }

    enum Detail {
        static let risingText = "Rising"
        static let fallingText = "Falling"
        static let stableText = "Stable"
        static let notFoundTitle = "Symbol Not Found"
        static let notFoundDescription = "No data available for"
    }

    enum Animation {
        static let flashDuration: TimeInterval = 1.0
        static let toastDuration: TimeInterval = 2.0
    }
}
