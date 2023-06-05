//
//  CoinDataView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct CoinDataView: View {
    
    // MARK: - Declaring variables
    let coin: Coin!
    
    // MARK: - UI
    var body: some View {
        VStack(alignment: .leading) {
            // "Headline" Data
            HStack(alignment: .center) {
                Text("\(coin.name) (\(coin.symbol))")
                    .font(.custom("Montserrat-Bold", size: 20.0))
                Spacer()
                Text("\(coin.changePercent24Hr.roundAsDouble(to: 2))%")
                    .font(.custom("Montserrat-Bold", size: 20.0))
                    .foregroundColor((Double(coin.changePercent24Hr) ?? 0.0) >= 0 ? .green : .red)
            }
            .padding(.bottom, 16.0)
                        
            // Detail Data
            VStack(alignment: .leading, spacing: 8.0) {
                Text("Rank: \(coin.rank)")
                    .font(.custom("Montserrat-Regular", size: 16.0))
                Text("Supply: \(coin.supply.roundAsDouble(to: 0))")
                    .font(.custom("Montserrat-Regular", size: 16.0))
                Text("Max Supply: \(coin.maxSupply == nil ? "n/a" : (coin.maxSupply ?? "").roundAsDouble(to: 0))")
                    .font(.custom("Montserrat-Regular", size: 16.0))
                Text("Price: $\(coin.priceUsd.roundAsDouble(to: 2))")
                    .font(.custom("Montserrat-Regular", size: 16.0))
            }
        }
        .padding(24.0)
        .background(.regularMaterial)
        .cornerRadius(16.0)
    }
}

struct CoinDataView_Previews: PreviewProvider {
    static var previews: some View {
        CoinDataView(coin: .defaultCoin)
    }
}
