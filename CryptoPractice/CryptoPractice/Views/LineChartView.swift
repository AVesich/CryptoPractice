//
//  LineChartView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI
import Charts

struct LineChartView: View {
    
    // MARK: - Declaring Variables
    @Binding var history: [StampedCoinValue]
    var color: Color

    // MARK: - UI
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let max = history.max { $0.priceUsd.toDouble() < $1.priceUsd.toDouble() }?.priceUsd.toDouble() ?? 0
                let min = history.min { $0.priceUsd.toDouble() < $1.priceUsd.toDouble() }?.priceUsd.toDouble() ?? 0
                let range = max-min
                for i in 0..<history.count {
                    let x = geometry.size.width/CGFloat(history.count) * CGFloat(i+1)
                    
                    let y = (history[i].priceUsd.toDouble()-min)/range * geometry.size.height
                    
                    if i == 0 { path.move(to: CGPoint(x: 0, y: y)) }
                    else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
            .rotation3DEffect(.degrees(180), axis: (x: 1, y:0, z:0))
        }
    }
}



struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(history: .constant([.init(priceUsd: "0", time: 0), .init(priceUsd: "1", time: 1)]), color: .orange)
    }
}
