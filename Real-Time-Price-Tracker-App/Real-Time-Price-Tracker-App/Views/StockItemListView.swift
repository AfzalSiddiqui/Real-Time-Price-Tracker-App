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
            tickerLabel
            Spacer()
            priceLabel
        }
        .padding(.vertical, 4)
        .listRowBackground(rowHighlight)
        .animation(.easeInOut(duration: 0.3), value: isFlashing)
    }

    private var tickerLabel: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stock.id)
                .font(.headline)
            Text(stock.name)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var priceLabel: some View {
        HStack(spacing: 4) {
            Text(stock.price, format: .currency(code: Constants.App.currencyCode))
                .font(.body.monospacedDigit())
                .fontWeight(.medium)
            Image(systemName: changeIcon)
                .foregroundStyle(changeColor)
                .font(.caption)
        }
    }

    // brief highlight on price change
    private var rowHighlight: Color? {
        guard isFlashing else { return nil }
        switch stock.priceDirection {
        case .up: return .green.opacity(0.15)
        case .down: return .red.opacity(0.15)
        case .unchanged: return nil
        }
    }

    private var changeIcon: String {
        switch stock.priceDirection {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .unchanged: return "minus"
        }
    }

    private var changeColor: Color {
        switch stock.priceDirection {
        case .up: return .green
        case .down: return .red
        case .unchanged: return .gray
        }
    }
}
