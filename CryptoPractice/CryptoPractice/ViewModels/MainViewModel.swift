//
//  MainViewModel.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import Foundation
import OrderedCollections

class MainViewModel: ObservableObject {
    // MARK: - Declaring Attributes
    // CoinLoader instance to download coin data periodically
    private let coinLoader = CoinDecoder()
    
    // Variables
    @Published var coinList = [Coin]() // The coin list
    @Published var favoritedCoins = OrderedSet<Coin>()
    @Published var searchText = "" // Text to be supplied by the search screen
    var searchedCoins: [Coin] {
        return searchText == "" ? coinList : coinList.filter {
            $0.name.contains(searchText.capitalized) // Coin names are stored capitalized, that is, with their first letter capitalized
        }
    }
    var highestMoving: [Coin] {
        coinList.sorted { $0.changePercent24Hr > $1.changePercent24Hr }
    }
    private let FAVORITES_KEY = "Favorites" // Key used for saving to userDefaults
    
    // MARK: - Initialization
    init() {
        // Download the coins
        downloadData()
        
        // Load the favorited coins
        self.favoritedCoins = loadFavorites()
    }
    
    // MARK: - Funcs
    // Download the coin list from the api
    public func downloadData() {
        // Download the coins and update the list if/when successful
        coinLoader.downloadCoins { coins in
            DispatchQueue.main.async {
                self.coinList = coins
                dump(self.coinList)
            }
        }
    }
    
    // Toggle if a coin is favorited
    public func editCoinFavStatus(coin: Coin) {
        // Contains should be o(1) for hashable sets, so we just do this.
        // Using a set circumvents the issue of coins being value type structs (favoriting in coin screen wouldn't change an instance in a list)
        // Also, since we are downloading coins from the internet, redownloading poses the issue of overwriting the previous coins & their favorite status
        if favoritedCoins.contains(coin) {
            _ = favoritedCoins.remove(coin) // _ = used to silence unused return value warnings
        } else {
            _ = favoritedCoins.append(coin)
        }
        saveFavorites()
    }
    
    // Return if a coin is favorited
    public func hasFavorite(coin: Coin) -> Bool {
        return favoritedCoins.contains(coin)
    }
    
    // Save the favorites to userDefaults
    private func saveFavorites() {
        do {
            let arr = Array(favoritedCoins)
            let data = try JSONEncoder().encode(arr)
            UserDefaults.standard.set(data, forKey: FAVORITES_KEY)
        } catch {
            print(error)
        }
    }
    
    // Load the favorites to userDefaults
    private func loadFavorites() -> OrderedSet<Coin> {
        if let data = UserDefaults.standard.data(forKey: FAVORITES_KEY) {
            if let favorites = try? JSONDecoder().decode([Coin].self, from: data) {
                return OrderedSet(favorites)
            }
        }
        return OrderedSet<Coin>()
    }
}
