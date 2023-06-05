//
//  Coin.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import Foundation

struct Coin: Codable, Identifiable, Hashable, Comparable {
    
    // Codable to be decoded from JSON, Indetifiable for search, and Hashable for NavigationDestination
    var id: String // The api's id for the coin, this is stored since structs must be identifiable to be searchable, so we need an id anyways.
    var rank: String // The api's rank for the coin, assuming this is based on price or market cap
    var symbol: String // The coin's symbol, for example: BTC
    var name: String // The coin's name, for example: Bitcoin
    var supply: String // The current number of coins available
    var maxSupply: String? // The maximum number of coins available
    var priceUsd: String // The current price of the coin in USD. The API returns prices in USD automatically.
    var changePercent24Hr: String // Positive or negative percentage change in coin value. The change is not fractional meaning 1% = 1, but does include a fractional part, example: 1.5% = 1.5
    var explorer: String? // Link for more info on the coin
    
    // Default value coin
    static let defaultCoin = Coin(id: "bitcoin",
                                  rank: "1",
                                  symbol: "BTC",
                                  name: "Bitcoin",
                                  supply: "19384712.0000000000000000",
                                  maxSupply: "21000000.0000000000000000",
                                  priceUsd: "26746.4287322291694203",
                                  changePercent24Hr: "1.2612372610905133",
                                  explorer: "https://blockchain.info/")
    
    // Comparator for pct change to simplify viewmodel logic
    static func < (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.changePercent24Hr < rhs.changePercent24Hr
    }
    
    // Equator for id to allow the favorites set to check if it contains a coin already regardless of changing values (besides id, name, & symbol)
    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hash func to ensure hashing is only done by id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CoinDataResponse: Codable {
    var data: [Coin]
}

struct StampedCoinValue: Codable {
    var priceUsd: String
    var time: Int64
}

struct CoinHistoryResponse: Codable {
    var data: [StampedCoinValue]
    
    enum historyInterval: String {
        // Minutes
        case M1 = "m1"
        case M5 = "m5"
        case M15 = "m15"
        case M30 = "m30"
        
        // Hours
        case H1 = "h1"
        case H2 = "h2"
        case H6 = "h6"
        case H12 = "h12"
        
        // Days
        case D1 = "d1"
    }
    
    enum historyStartTimes: Int {
        // Differences in unix ms from current time
        case HOUR = 3600000
        case DAY = 86400000
        case WEEK = 604800000
        case MONTH = 2678400000
        case YEAR = 1314000000
        case LIFE = 0
        
        // Interval necessary for the given start time to yield ~12 or more data points
        func interval() -> historyInterval {
            switch self {
            case .HOUR:
                return .M5 // will result in 12 data points every 5 mins
            case .DAY:
                return .H2 // will result in 12 data points every 2 hours
            case .WEEK:
                return .H12 // will return 14 data points every 12 hours
            case .MONTH:
                return .D1 // will return ~31 data points every day
            case .YEAR:
                return .D1 // will return ~365 data points every day
            case .LIFE:
                return .D1 // will return a point every day for the life of the coin
            }
        }
    }
}
