//
//  ContentView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(PriceTrackerViewModel.self) var vm

    var body: some View {
        @Bindable var vm = vm
        NavigationStack(path: $vm.navPath) {
            FeedView()
                .navigationDestination(for: String.self) { symbol in
                    SymbolDetailView(symbol: symbol)
                }
        }
    }
}
