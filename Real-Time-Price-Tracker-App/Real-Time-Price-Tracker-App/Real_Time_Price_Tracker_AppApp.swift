//
//  Real_Time_Price_Tracker_AppApp.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import SwiftUI

@main
struct Real_Time_Price_Tracker_AppApp: App {
    @StateObject private var viewModel = PriceTrackerViewModel()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewModel)
        }
    }
}
