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
        VStack(alignment: .leading, spacing: 3) {
            Text(stock.id)
                .font(.system(size: 16, weight: .semibold))
            Text(stock.name)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
    }

    private var priceLabel: some View {
        HStack(spacing: 5) {
            Text(stock.price, format: .currency(code: Constants.App.currencyCode))
                .font(.system(size: 15, weight: .medium).monospacedDigit())
            Image(systemName: stock.priceDirection.arrowName)
                .foregroundStyle(stock.priceDirection.color)
                .font(.system(size: 11))
        }
    }

    // brief highlight on price change
    private var rowHighlight: Color? {
        guard isFlashing, stock.priceDirection != .unchanged else { return nil }
        return stock.priceDirection.color.opacity(0.15)
    }
}
