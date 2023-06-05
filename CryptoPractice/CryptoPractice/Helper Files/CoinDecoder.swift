//
//  CoinLoader.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import Foundation

class CoinDecoder {
    // MARK: - Funcs
    func downloadCoins(completion: @escaping ([Coin]) -> ()) {
        JSONDownloader.shared.downloadData(fromURL: "https://api.coincap.io/v2/assets", model: CoinDataResponse.self) {
            completion($0.data)
        } failure: {
            print("ERROR: \($0)")
        }
    }
    
    func downloadCoinHistory(coinID: String, length: CoinHistoryResponse.historyStartTimes, completion: @escaping ([StampedCoinValue]) -> ()) {
        JSONDownloader.shared.downloadData(fromURL: "https://api.coincap.io/v2/assets/\(coinID)/history?interval=\(length.interval().rawValue)", model: CoinHistoryResponse.self) {
            if length == .LIFE {
                completion($0.data)
                return
            }
            
            let filtered = $0.data.filter { $0.time > (Int(Date.now.timeIntervalSince1970) * 1000 - length.rawValue) } // Trim data to elements within the specified length
            completion(filtered)
        } failure: {
            print("ERROR: \($0)")
        }
    }
}
