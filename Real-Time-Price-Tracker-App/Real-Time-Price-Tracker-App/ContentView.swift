//
//  ContentView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: PriceTrackerViewModel

    var body: some View {
        NavigationStack(path: $vm.navPath) {
            FeedView()
                .navigationDestination(for: String.self) { symbol in
                    SymbolDetailView(symbol: symbol)
                }
        }
    }
}
