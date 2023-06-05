//
//  SearchView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct SearchView: View {

    // MARK: - Declaring Variables
    @EnvironmentObject var viewModel: MainViewModel
    
    // MARK: - UI
    // Nav bar attribute setup
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Montserrat-Bold", size: 36.0)!]
    }
    
    // Main View
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                List {
                    ForEach(viewModel.searchedCoins) { coin in
                        NavigationLink(value: coin) {
                            CoinCell(coin: coin)
                        }
                        .frame(height: 38.0)
                    }
                }
                .animation(.easeIn(duration: 0.1), value: viewModel.searchedCoins.count)
                .scrollIndicators(.hidden)
                .listStyle(.insetGrouped)
                .searchable(text: $viewModel.searchText)
                .refreshable {
                    viewModel.downloadData()
                }
                
                // Navigation Title
                .navigationTitle("Search")
                
                // Navigation Destinations for stack
                .navigationDestination(for: Coin.self) {
                    CoinView(coin: $0)
                }
            }
        }.onAppear( perform: { viewModel.downloadData() } )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(MainViewModel())
    }
}
