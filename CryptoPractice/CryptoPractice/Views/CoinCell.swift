//
//  CoinCell.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct CoinCell: View {
    
    // MARK: - Declaring variables
    let coin: Coin!

    // MARK: - UI
    var body: some View {
        HStack(alignment: .center) {
            Text("\(coin.name) (\(coin.symbol))")
                .font(.custom("Montserrat-Bold", size: 14.0))
            Spacer()
            Text(String(format:"%.2f%%", Double(coin.changePercent24Hr) ?? 0.0))//coin.changePercent24Hr))
                .font(.custom("Montserrat-Bold", size: 14.0))
                .foregroundColor((Double(coin.changePercent24Hr) ?? 0.0) >= 0 ? .green : .red)
        }
    }
}

struct CoinCell_Previews: PreviewProvider {
    static var previews: some View {
        CoinCell(coin: .defaultCoin)
    }
}
