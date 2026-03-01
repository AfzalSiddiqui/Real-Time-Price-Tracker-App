//
//  SymbolDetailView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import SwiftUI

struct SymbolDetailView: View {
    @EnvironmentObject var vm: PriceTrackerViewModel
    let symbol: String

    private var stock: StockItem? { vm.stock(for: symbol) }
    private var isFlashing: Bool { vm.highlightedSymbols.contains(symbol) }

    var body: some View {
        if let stock = stock {
            detailBody(stock)
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

    // MARK: - Layout

    private func detailBody(_ stock: StockItem) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                priceDisplay(stock)
                aboutSection(stock)
                Spacer()
            }
        }
    }

    private func priceDisplay(_ stock: StockItem) -> some View {
        VStack(spacing: 8) {
            Text(stock.price, format: .currency(code: Constants.App.currencyCode))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isFlashing ? tintColor(stock) : .primary)
                .animation(.easeInOut(duration: 0.3), value: isFlashing)

            HStack(spacing: 6) {
                Image(systemName: changeIcon(stock))
                Text(changeLabel(stock))
            }
            .font(.title3)
            .foregroundStyle(tintColor(stock))
        }
        .padding(.top, 32)
    }

    private func aboutSection(_ stock: StockItem) -> some View {
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

    private func changeIcon(_ stock: StockItem) -> String {
        switch stock.priceDirection {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .unchanged: return "minus"
        }
    }

    private func changeLabel(_ stock: StockItem) -> String {
        switch stock.priceDirection {
        case .up: return Constants.Detail.risingText
        case .down: return Constants.Detail.fallingText
        case .unchanged: return Constants.Detail.stableText
        }
    }

    private func tintColor(_ stock: StockItem) -> Color {
        switch stock.priceDirection {
        case .up: return .green
        case .down: return .red
        case .unchanged: return .gray
        }
    }
}
