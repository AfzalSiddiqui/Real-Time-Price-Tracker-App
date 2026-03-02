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
    }

    enum Connection {
        static let startButton = "Start"
        static let stopButton = "Stop"
    }

    enum Detail {
        static let risingText = "Rising"
        static let fallingText = "Falling"
        static let stableText = "Stable"
        static let notFoundTitle = "Symbol Not Found"
        static let notFoundDescription = "No data available for"
    }
}
