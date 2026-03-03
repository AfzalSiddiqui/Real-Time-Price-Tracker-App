# Real-Time Price Tracker App

SwiftUI app that tracks live stock prices for 25 symbols using a WebSocket echo server. Prices update every 2 seconds with visual indicators for price movement.

## Overview

The app connects to `wss://ws.postman-echo.com/raw` and simulates a real-time price feed. Every 2 seconds it generates random price updates for each symbol, sends them to the echo server, and uses the response to update the UI. The list stays sorted by price (highest first) and re-sorts automatically on every update.

There are two screens — a feed screen showing all 25 stocks, and a detail screen you get to by tapping any row. Both screens stay in sync since they share the same ViewModel, so there's only one WebSocket connection running at a time.

## Screens

**Feed Screen**
- Scrollable list with symbol name, current price, and green ↑ / red ↓ arrows
- Top bar has a connection status dot on the left (green/red/orange) and a Start/Stop button on the right
- Rows briefly flash green or red when the price changes
- Shows a toast when connection status changes (connected, disconnected, connecting)

**Detail Screen**
- Symbol name in the navigation bar
- Large price display with direction indicator
- Company description in a grouped box

## Architecture

MVVM — the ViewModel (`PriceTrackerViewModel`) is created as a `@StateObject` at the app level and passed down via `@EnvironmentObject`. It owns the `WebSocketService` and binds to the views through `@Published` properties.

The WebSocket layer uses `URLSessionWebSocketTask` with a delegate for lifecycle callbacks. Price data comes back through Combine (`$priceUpdates` sink), the ViewModel applies the updates, re-sorts the list, and SwiftUI handles the rest. Navigation is a `NavigationStack` with value-based routing, and deep links (`stocks://symbol/AAPL`) go through `.onOpenURL`.

## Running the App

1. Open `Real-Time-Price-Tracker-App.xcodeproj` in Xcode 26+
2. Pick an iOS 26 simulator
3. Cmd+R to build and run
4. Hit **Start** to kick off the price feed

To test deep links:
```
xcrun simctl openurl booted "stocks://symbol/AAPL"
```

## Project Structure

```
Real-Time-Price-Tracker-App/
├── Model/
│   └── StockItem.swift
├── ViewModels/
│   └── PriceTrackerViewModel.swift
├── Views/
│   ├── FeedView.swift
│   ├── StockItemListView.swift
│   ├── SymbolDetailView.swift
│   └── SplashScreenView.swift
├── Services/
│   └── WebSocketService.swift
├── Utilities/
│   └── Constants.swift
├── ContentView.swift
├── Real_Time_Price_Tracker_AppApp.swift
└── Info.plist
```
