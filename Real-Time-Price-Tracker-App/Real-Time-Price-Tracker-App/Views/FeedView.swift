//
//  FeedView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: PriceTrackerViewModel

    var body: some View {
        List(viewModel.stocks) { stock in
            NavigationLink(value: stock.id) {
                StockItemListView(stock: stock)
            }
        }
        .listStyle(.plain)
        .navigationTitle(Constants.App.title)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // connection indicator dot
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(viewModel.isFeedActive ? Constants.Connection.stopButton : Constants.Connection.startButton) {
                    viewModel.toggleFeed()
                }
                .fontWeight(.semibold)
            }
        }
    }

    private var statusColor: Color {
        switch viewModel.connectionStatus {
        case .connected: return .green
        case .disconnected: return .red
        case .connecting: return .orange
        }
    }
}
