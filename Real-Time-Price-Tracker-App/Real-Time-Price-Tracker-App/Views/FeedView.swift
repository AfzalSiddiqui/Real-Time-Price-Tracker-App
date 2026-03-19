//
//  FeedView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 01/03/2026.
//

import SwiftUI

struct FeedView: View {
    @Environment(PriceTrackerViewModel.self) var vm
    @State private var toastMessage: String?
    @State private var showToast = false
    @State private var toastTask: Task<Void, Never>?

    var body: some View {
        ZStack(alignment: .top) {
            List(vm.stocks) { stock in
                NavigationLink(value: stock.id) {
                    StockItemListView(
                        stock: stock,
                        isFlashing: vm.highlightedSymbols.contains(stock.id)
                    )
                }
            }
            .listStyle(.plain)

            // toast near toolbar
            if showToast, let msg = toastMessage {
                Text(msg)
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .shadow(radius: 4)
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showToast)
        .navigationTitle(Constants.App.title)
        .navigationBarTitleDisplayMode(.inline)
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
        .onChange(of: vm.connectionStatus) { _, newStatus in
            showStatusToast(newStatus)
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

    private func showStatusToast(_ status: ConnectionStatus) {
        toastTask?.cancel()

        switch status {
        case .connected:  toastMessage = Constants.Connection.connectedText
        case .disconnected: toastMessage = Constants.Connection.disconnectedText
        case .connecting: toastMessage = Constants.Connection.connectingText
        }

        withAnimation { showToast = true }

        toastTask = Task {
            try? await Task.sleep(for: .seconds(Constants.Animation.toastDuration))
            guard !Task.isCancelled else { return }
            withAnimation { showToast = false }
        }
    }
}
