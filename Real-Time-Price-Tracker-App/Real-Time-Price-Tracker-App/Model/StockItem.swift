//
//  StockItem.swift
//  Real-Time-Price-Tracker-App
//
//  Created by Afzal on 28/02/2026.
//

import Foundation

struct StockItem: Identifiable, Equatable {
    let id: String          // ticker symbol e.g. "AAPL"
    let name: String
    let description: String
    var price: Double
    var previousPrice: Double

    /// Compare current vs previous price to show direction arrow
    var priceDirection: PriceDirection {
        if price > previousPrice { return .up }
        if price < previousPrice { return .down }
        return .unchanged
    }
}

enum PriceDirection {
    case up, down, unchanged
}

enum ConnectionStatus: Equatable {
    case connected, disconnected, connecting
}

// Wire format for WebSocket messages
struct PriceUpdate: Codable, Equatable {
    let symbol: String
    let price: Double
    let timestamp: Date
}

// MARK: - Stock catalog (25 symbols)

enum StockCatalog {
    static let symbols: [(symbol: String, name: String, description: String)] = [
        ("AAPL", "Apple Inc.",
         "Apple designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories. The company also offers digital content, streaming, and cloud services."),
        ("GOOG", "Alphabet Inc.",
         "Alphabet is the parent company of Google, specializing in internet services including search, advertising, cloud computing, and hardware products."),
        ("TSLA", "Tesla Inc.",
         "Tesla designs, develops, manufactures, and sells electric vehicles, energy storage systems, and solar energy generation products worldwide."),
        ("AMZN", "Amazon.com Inc.",
         "Amazon is a multinational technology company focused on e-commerce, cloud computing (AWS), digital streaming, and artificial intelligence."),
        ("MSFT", "Microsoft Corp.",
         "Microsoft develops and supports software, services, devices, and solutions including Windows, Office, Azure, and gaming products."),
        ("NVDA", "NVIDIA Corp.",
         "NVIDIA designs GPUs and system-on-chip units for gaming, professional visualization, data centers, and automotive markets. A leader in AI computing."),
        ("META", "Meta Platforms Inc.",
         "Meta operates social media platforms including Facebook, Instagram, and WhatsApp, and is investing in virtual and augmented reality technologies."),
        ("NFLX", "Netflix Inc.",
         "Netflix is a streaming entertainment service offering TV series, documentaries, feature films, and mobile games across a wide variety of genres and languages."),
        ("AMD", "Advanced Micro Devices",
         "AMD designs and produces microprocessors, GPUs, and related technologies for computing, gaming, and enterprise markets."),
        ("INTC", "Intel Corp.",
         "Intel designs and manufactures essential computing technologies including microprocessors, chipsets, and integrated circuits for data centers and PCs."),
        ("CRM", "Salesforce Inc.",
         "Salesforce provides cloud-based customer relationship management (CRM) software and enterprise applications focused on sales, service, and marketing."),
        ("ORCL", "Oracle Corp.",
         "Oracle provides cloud infrastructure, database technologies, and enterprise software applications for businesses of all sizes worldwide."),
        ("ADBE", "Adobe Inc.",
         "Adobe offers creative, document, and digital experience solutions including Photoshop, Illustrator, Acrobat, and the Experience Cloud platform."),
        ("PYPL", "PayPal Holdings Inc.",
         "PayPal operates a digital payments platform that enables consumers and merchants to send and receive payments online and in stores."),
        ("SQ", "Block Inc.",
         "Block (formerly Square) provides financial services and mobile payment solutions for businesses and individuals through its ecosystem of tools."),
        ("SHOP", "Shopify Inc.",
         "Shopify provides a commerce platform enabling merchants to set up online stores, manage sales, marketing, shipping, and payments."),
        ("UBER", "Uber Technologies Inc.",
         "Uber operates a platform connecting riders with drivers, and eaters with restaurants, offering ride-sharing, food delivery, and freight services."),
        ("LYFT", "Lyft Inc.",
         "Lyft operates a peer-to-peer ride-sharing platform in the United States and Canada, offering rides, bikes, and scooters."),
        ("SNAP", "Snap Inc.",
         "Snap operates Snapchat, a visual messaging app, and develops camera and social media products focused on augmented reality experiences."),
        ("PINS", "Pinterest Inc.",
         "Pinterest is a visual discovery engine that helps users find inspiration for recipes, home, style, and other interests through image sharing and bookmarking."),
        ("TWTR", "Twitter / X Corp.",
         "X (formerly Twitter) is a social media platform for public conversations, news sharing, and real-time communication through short-form messages."),
        ("COIN", "Coinbase Global Inc.",
         "Coinbase is a cryptocurrency exchange platform that allows users to buy, sell, transfer, and store digital currencies securely."),
        ("HOOD", "Robinhood Markets Inc.",
         "Robinhood provides commission-free trading of stocks, ETFs, options, and cryptocurrencies through its mobile-first financial services platform."),
        ("PLTR", "Palantir Technologies",
         "Palantir builds software platforms for data integration and analytics, serving government agencies and commercial enterprises worldwide."),
        ("RBLX", "Roblox Corp.",
         "Roblox operates an online entertainment platform where users can create, share, and play immersive 3D experiences built by its community of developers.")
    ]

    /// Generates initial stock data with random base prices
    static func initialStocks() -> [StockItem] {
        symbols.map { item in
            let basePrice = Double.random(in: 20...500)
            return StockItem(
                id: item.symbol,
                name: item.name,
                description: item.description,
                price: basePrice,
                previousPrice: basePrice  // same initially so direction = .unchanged
            )
        }
    }
}
