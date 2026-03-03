//
//  SplashScreenView.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            ContentView()
        } else {
            splashContent
                .onAppear {
                    // brief delay then transition to main content
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.App.splashDelay) {
                        withAnimation { isActive = true }
                    }
                }
        }
    }

    private var splashContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 64))
                .foregroundStyle(.blue)
            Text(Constants.App.title)
                .font(.largeTitle.bold())
            Text(Constants.App.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
