//
//  FavoriteView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct FavoriteView: View {
    
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
            List {
                PieChartView()
                    .padding(24.0)
                
                Section("Your Favorite Coins") {
                    ForEach(Array(viewModel.favoritedCoins.enumerated()), id: \.offset) { o, e in
                        // .sorted solves set not being random access & sorts by highest moving
                        HStack(alignment: .center, spacing: 16.0) {
                            RoundedRectangle(cornerRadius: 4.0)
                                .foregroundColor(Color(red: Double((31 * o) % 255)/255.0,
                                                       green: Double((45 * o) % 255)/255.0,
                                                       blue: Double((53 * o) % 255)/255.0))
                                .frame(width: 22.0, height: 22.0)
                            CoinCell(coin: e) // No nav link this time
                        }
                        .frame(height: 38.0)
                    }
                }
            }
            .refreshable {
                viewModel.downloadData()
            }
            
            // Nav title
            .navigationTitle("Favorites")
        }
        .onAppear( perform: { viewModel.downloadData() } )
        .environmentObject(viewModel)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(MainViewModel())
    }
}
