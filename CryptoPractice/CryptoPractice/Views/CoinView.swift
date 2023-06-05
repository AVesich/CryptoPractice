//
//  CoinView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct CoinView: View {
    
    // MARK: - Declaring variables
    @StateObject var graphViewModel = GraphViewModel()
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment (\.openURL) var openURL
    let coin: Coin!
        
    // MARK: - UI
    var body: some View {
        VStack(alignment: .leading, spacing: 24.0) {
            // Chart and settings
            VStack(alignment: .leading, spacing: 8.0) {
                LineChartView(history: $graphViewModel.historyData, color: .blue)
                Picker ("Time Frame", selection: $graphViewModel.historyLength) {
                    Text("Past Hour").tag(CoinHistoryResponse.historyStartTimes.HOUR)
                    Text("Past Day").tag(CoinHistoryResponse.historyStartTimes.DAY)
                    Text("Past Week").tag(CoinHistoryResponse.historyStartTimes.WEEK)
                    Text("Past Month").tag(CoinHistoryResponse.historyStartTimes.MONTH)
                    Text("Past Year").tag(CoinHistoryResponse.historyStartTimes.YEAR)
                    Text("Market Life").tag(CoinHistoryResponse.historyStartTimes.LIFE)
                }
                .onChange(of: graphViewModel.historyLength,
                           perform: {_ in graphViewModel.loadHistoryData(coin: coin) })
                .pickerStyle(.menu)
            }
            .padding(.top, 24.0)
            
            // Data
            CoinDataView(coin: coin)
            Button {
                openURL(URL(string: coin.explorer ?? "www.google.com")!)
            } label: {
                Text("Find Online")
                    .font(.custom("Montserrat-Bold", size: 16.0))
                    .frame(maxWidth: .infinity, maxHeight: 48)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(16.0)
            .opacity(coin.explorer != nil ? 1.0 : 0.0)
            Spacer()
            
            // Nav
            .navigationTitle(coin.name)
            .toolbar {
                Button {
                    mainViewModel.editCoinFavStatus(coin: coin)
                } label: {
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .padding(2.0)
                }
                .buttonStyle(.bordered)
                .foregroundColor(mainViewModel.hasFavorite(coin: coin) ? .pink : .gray)
                .buttonBorderShape(.capsule)
            }
        }
        .padding(.horizontal, 24.0)
        .onAppear(perform: { graphViewModel.loadHistoryData(coin: coin) } )
        .environmentObject(graphViewModel)
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(graphViewModel: GraphViewModel(), coin: .defaultCoin)
            .environmentObject(MainViewModel())
    }
}
