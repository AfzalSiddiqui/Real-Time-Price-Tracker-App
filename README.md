# Real-Time-Price-Tracker-App
Real-Time Price Tracker App

A clean iOS app that shows live stock prices — built with **SwiftUI**.

Right now it displays a list of 25 popular stock symbols with placeholder prices. The plan is to bring in real-time WebSocket updates so prices actually move.

## Current state

- Project set up with **SwiftUI**
- Classic MVVM folder structure  
  (`Models` • `Views` • `ViewModels` • `Services`)
- Main **Feed screen**:
  - Scrollable list of 25 symbols
  - Each row shows symbol + placeholder price
  - Tap row → detail screen
- **Symbol detail screen**:
  - Symbol name as title
  - Large price placeholder
  - Space prepared for description / company info
- Smooth navigation using **NavigationStack**
- Basic ViewModels with `@Published` properties already wired up

Static version looks good — now ready for live data.

## Next steps

- Connect real **WebSocket** for live price streaming
- Show price changes with green ↑ / red ↓ indicators
- Option to sort list by price or % change
- Add **Start / Stop** feed toggle + connection status
- Pull in real company names + short descriptions
- Small UI polish (colors, spacing, typography)

## Quick note

This commit is the solid foundation: structure, navigation, static feed of 25 symbols, basic MVVM setup.

Live prices and the fun part start in the next commits.

Thanks for checking it out!