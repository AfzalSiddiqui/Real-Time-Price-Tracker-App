//
//  FeedView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var vm: PriceTrackerViewModel

    var body: some View {
        List(vm.stocks) { stock in
            NavigationLink(value: stock.id) {
                StockItemListView(
                    stock: stock,
                    isFlashing: vm.highlightedSymbols.contains(stock.id)
                )
            }
        }
        .listStyle(.plain)
        .navigationTitle(Constants.App.title)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Circle()
                    .fill(indicatorColor)
                    .frame(width: 12, height: 12)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(vm.isFeedActive ? Constants.Connection.stopButton : Constants.Connection.startButton) {
                    vm.toggleFeed()
                }
                .fontWeight(.semibold)
            }
        }
    }

    // green = connected, red = offline, orange = in progress
    private var indicatorColor: Color {
        switch vm.connectionStatus {
        case .connected: return .green
        case .disconnected: return .red
        case .connecting: return .orange
        }
    }
}
