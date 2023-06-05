//
//  HomeView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Declaring Variables
    @EnvironmentObject var viewModel: MainViewModel
    
    // MARK: - UI
    // Nav bar attribute setup
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Montserrat-Bold", size: 36.0)!]
    }
    
    // Main View
    var body: some View {
        // Nav stack for navlinks
        NavigationStack {
            // Main VStack
            VStack (alignment: .leading) {
                List {
                    // Top ranked Coins
                    Section("Top Coins") {
                        ForEach(viewModel.coinList.prefix(5)) { coin in
                            NavigationLink (value: coin) {
                                CoinCell(coin: coin)
                            }
                        }
                    }
                    
                    // Biggest % change coins
                    Section("Biggest Movers") {
                        ForEach(viewModel.highestMoving.prefix(5)) { coin in
                            NavigationLink (value: coin) {
                                CoinCell(coin: coin)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .listStyle(.insetGrouped)
                .refreshable {
                    viewModel.downloadData()
                }
            }
            
            // Navigation Title
            .navigationTitle("Hey, Austin! 👋")
            
            // Navigation Destinations for stack
            .navigationDestination(for: Coin.self) {
                CoinView(coin: $0)
            }
        } .onAppear( perform: { viewModel.downloadData() } )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(MainViewModel())
    }
}
