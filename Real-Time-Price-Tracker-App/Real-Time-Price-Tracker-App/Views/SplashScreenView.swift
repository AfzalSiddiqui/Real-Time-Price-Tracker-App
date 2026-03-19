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
                .task {
                    try? await Task.sleep(for: .seconds(Constants.App.splashDelay))
                    withAnimation { isActive = true }
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
