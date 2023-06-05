//
//  GraphViewModel.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/28/23.
//

import Foundation

class GraphViewModel: ObservableObject {
    
    // MARK: - Declaring Variables
    // CoinLoader instance to download coin data periodically
    private let coinLoader = CoinDecoder()
    
    @Published var historyData = [StampedCoinValue]()
    @Published var historyLength = CoinHistoryResponse.historyStartTimes.HOUR
            
    // MARK: - Funcs
    public func loadHistoryData(coin: Coin) {
        coinLoader.downloadCoinHistory(coinID: coin.id, length: historyLength) { history in
            DispatchQueue.main.async {
                self.historyData = history
            }
        }
    }
}
