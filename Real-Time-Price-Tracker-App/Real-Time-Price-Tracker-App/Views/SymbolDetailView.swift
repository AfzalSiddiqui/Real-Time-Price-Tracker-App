//
//  SymbolDetailView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import SwiftUI

struct SymbolDetailView: View {
    @EnvironmentObject var viewModel: PriceTrackerViewModel
    let symbol: String

    private var stock: StockItem? {
        viewModel.stock(for: symbol)
    }

    var body: some View {
        if let stock = stock {
            stockDetailContent(stock)
                .navigationTitle(stock.id)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView(
                Constants.Detail.notFoundTitle,
                systemImage: "magnifyingglass",
                description: Text("\(Constants.Detail.notFoundDescription) \(symbol)")
            )
        }
    }

    // MARK: - Detail content

    private func stockDetailContent(_ stock: StockItem) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                priceSection(stock)
                descriptionSection(stock)
                Spacer()
            }
        }
    }

    private func priceSection(_ stock: StockItem) -> some View {
        VStack(spacing: 8) {
            Text(stock.price, format: .currency(code: Constants.App.currencyCode))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 6) {
                Image(systemName: directionIcon(for: stock))
                Text(directionText(for: stock))
            }
            .font(.title3)
            .foregroundStyle(directionColor(for: stock))
        }
        .padding(.top, 32)
    }

    private func descriptionSection(_ stock: StockItem) -> some View {
        GroupBox {
            Text(stock.description)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label("About \(stock.name)", systemImage: "info.circle")
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers

    private func directionIcon(for stock: StockItem) -> String {
        switch stock.priceDirection {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .unchanged: return "minus"
        }
    }

    private func directionText(for stock: StockItem) -> String {
        switch stock.priceDirection {
        case .up: return Constants.Detail.risingText
        case .down: return Constants.Detail.fallingText
        case .unchanged: return Constants.Detail.stableText
        }
    }

    private func directionColor(for stock: StockItem) -> Color {
        switch stock.priceDirection {
        case .up: return .green
        case .down: return .red
        case .unchanged: return .gray
        }
    }
}
