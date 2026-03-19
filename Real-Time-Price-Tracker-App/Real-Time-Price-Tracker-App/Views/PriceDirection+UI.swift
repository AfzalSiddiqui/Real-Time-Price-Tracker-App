//
//  PriceDirection+UI.swift
//  Real-Time-Price-Tracker-App
//

import SwiftUI

extension PriceDirection {

    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .unchanged: return .gray
        }
    }

    var arrowName: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .unchanged: return "minus"
        }
    }
}
