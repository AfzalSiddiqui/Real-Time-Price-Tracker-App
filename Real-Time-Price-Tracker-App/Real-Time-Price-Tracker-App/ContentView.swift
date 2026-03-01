//
//  ContentView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Amal on 28/02/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: PriceTrackerViewModel

    var body: some View {
        NavigationStack {
            FeedView()
                .navigationDestination(for: String.self) { symbol in
                    SymbolDetailView(symbol: symbol)
                }
        }
    }
}
