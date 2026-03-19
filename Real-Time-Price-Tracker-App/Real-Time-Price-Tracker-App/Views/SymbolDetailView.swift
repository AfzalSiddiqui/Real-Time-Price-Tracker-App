//
//  SymbolDetailView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import SwiftUI

struct SymbolDetailView: View {
    @Environment(PriceTrackerViewModel.self) var vm
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
        let direction = stock.priceDirection

        return VStack(spacing: 8) {
            Text(stock.price, format: .currency(code: Constants.App.currencyCode))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isFlashing ? direction.color : .primary)
                .animation(.easeInOut(duration: 0.3), value: isFlashing)

            HStack(spacing: 5) {
                Image(systemName: direction.arrowName)
                    .font(.system(size: 15))
                Text(directionLabel(direction))
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(direction.color)
        }
        .padding(.top, 32)
    }

    private func aboutSection(_ stock: StockItem) -> some View {
        GroupBox {
            Text(stock.about)
                .font(.system(size: 14))
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label("About \(stock.name)", systemImage: "info.circle")
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal)
    }

    private func directionLabel(_ dir: PriceDirection) -> String {
        switch dir {
        case .up: return Constants.Detail.risingText
        case .down: return Constants.Detail.fallingText
        case .unchanged: return Constants.Detail.stableText
        }
    }
}
