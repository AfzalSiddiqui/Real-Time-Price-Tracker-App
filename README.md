# Real-Time Price Tracker App

SwiftUI app that tracks live stock prices for 25 symbols using a WebSocket echo server. Prices update every 2 seconds with visual indicators for price movement.

## Overview

The app connects to `wss://ws.postman-echo.com/raw` and simulates a real-time price feed. Every 2 seconds it generates random price updates for each symbol, sends them to the echo server, and uses the response to update the UI. The list stays sorted by price (highest first) and re-sorts automatically on every update.

There are two screens — a feed screen showing all 25 stocks, and a detail screen you get to by tapping any row. Both screens stay in sync since they share the same ViewModel, so there's only one WebSocket connection running at a time. Rows briefly flash green/red on price changes, and a toast pops up when the connection status changes.

Deep links are supported — `stocks://symbol/AAPL` opens the detail screen directly.

## Screens

**Feed Screen**
- Scrollable list with symbol name, current price, and green ↑ / red ↓ arrows
- Top bar: connection status dot (left) and Start/Stop toggle (right)
- Rows flash green or red for 1 second on price change
- Toast notification on connect/disconnect/connecting

**Detail Screen**
- Symbol name in the navigation bar
- Large price display with direction indicator
- Company description in a grouped box

## Architecture

MVVM with protocol-based service layer. The ViewModel (`PriceTrackerViewModel`) is created as a `@StateObject` at the app level and shared via `@EnvironmentObject`.

The WebSocket layer sits behind a `PriceFeedProvider` protocol — the ViewModel depends on the abstraction, not the concrete `WebSocketService`. This keeps things testable and follows dependency inversion. The service exposes Combine publishers (`statusPublisher`, `pricePublisher`), and the ViewModel subscribes to these for all data flow. No callbacks, no delegates leaking into the ViewModel — just Combine end to end.

`URLSessionWebSocketTask` handles the actual connection, with a delegate for lifecycle events. Navigation is `NavigationStack` with value-based routing, and deep links go through `.onOpenURL`.

All hardcoded values (URLs, intervals, strings) live in a single `Constants.swift` file.

## Running the App

1. Open `Real-Time-Price-Tracker-App.xcodeproj` in Xcode 26+
2. Pick an iOS 26 simulator
3. Cmd+R to build and run
4. Hit **Start** to kick off the price feed

To test deep links:
```
xcrun simctl openurl booted "stocks://symbol/AAPL"
```

## Tests

21 unit tests across 3 files covering models, ViewModel logic, and service state. Run with Cmd+U in Xcode.

## Project Structure

```
Real-Time-Price-Tracker-App/
├── Model/
│   └── StockItem.swift          # StockItem, PriceUpdate, PriceDirection, StockCatalog
├── ViewModels/
│   └── PriceTrackerViewModel.swift
├── Views/
│   ├── FeedView.swift           # Main list + toast
│   ├── StockItemListView.swift  # Single row
│   ├── SymbolDetailView.swift   # Detail screen
│   └── SplashScreenView.swift
├── Services/
│   └── WebSocketService.swift   # PriceFeedProvider protocol + WebSocket impl
├── Utilities/
│   └── Constants.swift          # All app constants in one place
├── ContentView.swift
├── Real_Time_Price_Tracker_AppApp.swift
└── Info.plist                   # URL scheme for deep links
```
