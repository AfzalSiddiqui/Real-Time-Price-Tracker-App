//
//  StockItemListView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import SwiftUI

struct StockItemListView: View {
    let stock: StockItem
    var isFlashing: Bool = false

    var body: some View {
        HStack {
            symbolInfo
            Spacer()
            priceInfo
        }
        .padding(.vertical, 4)
    }

    private var symbolInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stock.id)
                .font(.headline)
            Text(stock.name)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var priceInfo: some View {
        HStack(spacing: 4) {
            Text(stock.price, format: .currency(code: Constants.App.currencyCode))
                .font(.body.monospacedDigit())
                .fontWeight(.medium)

            Image(systemName: arrowIcon)
                .foregroundStyle(arrowColor)
                .font(.caption)
        }
    }

    // green arrow up, red arrow down, gray dash
    private var arrowIcon: String {
        switch stock.priceDirection {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .unchanged: return "minus"
        }
    }

    private var arrowColor: Color {
        switch stock.priceDirection {
        case .up: return .green
        case .down: return .red
        case .unchanged: return .gray
        }
    }
}
