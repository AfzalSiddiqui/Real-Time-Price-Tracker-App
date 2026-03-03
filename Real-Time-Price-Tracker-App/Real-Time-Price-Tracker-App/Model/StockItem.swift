//
//  StockItem.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import Foundation
import SwiftUI

struct StockItem: Identifiable, Equatable {
    let id: String          // ticker e.g. "AAPL"
    let name: String
    let description: String
    var price: Double
    var previousPrice: Double

    var priceDirection: PriceDirection {
        if price > previousPrice { return .up }
        if price < previousPrice { return .down }
        return .unchanged
    }
}

enum PriceDirection {
    case up, down, unchanged

    var arrowName: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .unchanged: return "minus"
        }
    }

    var color: Color {
        switch self {
        case .up: return .green
        case .down: return .red
        case .unchanged: return .gray
        }
    }
}

enum ConnectionStatus: Equatable {
    case connected, disconnected, connecting
}

struct PriceUpdate: Codable, Equatable {
    let symbol: String
    let price: Double
    let timestamp: Date
}

// MARK: - Catalog

enum StockCatalog {
    static let symbols: [(symbol: String, name: String, description: String)] = [
        ("AAPL", "Apple Inc.",
         "Consumer electronics and software. Known for iPhone, Mac, iPad, and services like iCloud and Apple Music."),
        ("GOOG", "Alphabet Inc.",
         "Parent company of Google. Runs search, YouTube, Android, and Google Cloud."),
        ("TSLA", "Tesla Inc.",
         "Electric vehicle maker that also does energy storage and solar panels."),
        ("AMZN", "Amazon.com Inc.",
         "Started as an online bookstore, now runs the biggest cloud platform (AWS) alongside its e-commerce and streaming businesses."),
        ("MSFT", "Microsoft Corp.",
         "Makes Windows, Office 365, Azure, Xbox, and LinkedIn. One of the largest companies by market cap."),
        ("NVDA", "NVIDIA Corp.",
         "GPU maker that became the backbone of AI computing. Also big in gaming and data center hardware."),
        ("META", "Meta Platforms Inc.",
         "Runs Facebook, Instagram, and WhatsApp. Spending heavily on VR/AR under the Meta rebrand."),
        ("NFLX", "Netflix Inc.",
         "Streaming giant with a huge original content library. Available in pretty much every country."),
        ("AMD", "Advanced Micro Devices",
         "CPUs and GPUs competing with Intel and NVIDIA. Popular in gaming PCs and servers."),
        ("INTC", "Intel Corp.",
         "Legacy chip company making processors for PCs and data centers. Trying to get back into the foundry business."),
        ("CRM", "Salesforce Inc.",
         "Cloud CRM platform — basically invented SaaS. Keeps growing through acquisitions like Slack and Tableau."),
        ("ORCL", "Oracle Corp.",
         "Enterprise databases and cloud infra. Been around since the 80s, now pushing hard into cloud services."),
        ("ADBE", "Adobe Inc.",
         "Creative software — Photoshop, Illustrator, Premiere Pro. Also has a digital experience platform for marketers."),
        ("PYPL", "PayPal Holdings Inc.",
         "Online payments platform for sending money, paying merchants, and handling transactions. Used by millions of sellers."),
        ("SQ", "Block Inc.",
         "Formerly Square. Makes the Square payment terminals and runs Cash App for peer-to-peer payments."),
        ("SHOP", "Shopify Inc.",
         "E-commerce platform for small and mid-size businesses. Handles storefronts, payments, and shipping in one place."),
        ("UBER", "Uber Technologies Inc.",
         "Ride-hailing and food delivery (Uber Eats). Also getting into freight logistics."),
        ("LYFT", "Lyft Inc.",
         "Ride-sharing company focused on the US and Canada. Competes head-to-head with Uber."),
        ("SNAP", "Snap Inc.",
         "Makes Snapchat — big on AR filters and disappearing messages. Mainly popular with younger demographics."),
        ("PINS", "Pinterest Inc.",
         "Visual discovery platform where people save ideas for recipes, home decor, fashion, and DIY projects."),
        ("TWTR", "Twitter / X Corp.",
         "Social platform rebranded to X. Known for real-time news, short posts, and public conversations."),
        ("COIN", "Coinbase Global Inc.",
         "Biggest US crypto exchange. Buy, sell, and store Bitcoin, Ethereum, and a bunch of other tokens."),
        ("HOOD", "Robinhood Markets Inc.",
         "Commission-free trading app that got popular with retail investors during the meme stock era."),
        ("PLTR", "Palantir Technologies",
         "Data analytics for government and enterprise. Known for big contracts with defense and intelligence agencies."),
        ("RBLX", "Roblox Corp.",
         "Online gaming platform where users build and play each other's games. Massive with kids and teens.")
    ]

    static func initialStocks() -> [StockItem] {
        symbols.map { entry in
            let base = Double.random(in: 20...500)
            return StockItem(
                id: entry.symbol,
                name: entry.name,
                description: entry.description,
                price: base,
                previousPrice: base
            )
        }
    }
}
