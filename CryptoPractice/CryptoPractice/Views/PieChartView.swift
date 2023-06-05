//
//  PieChartView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI
import Charts

struct PieChartView: View {
    
    // MARK: - Declaring Variables
    @EnvironmentObject var mainViewModel: MainViewModel
    
    // MARK: - Creating the graph
    var body: some View {
        let count = mainViewModel.favoritedCoins.count
        ZStack {
            ForEach(Array(mainViewModel.favoritedCoins.enumerated()), id: \.offset) { o, e in
                PieSlice(angle: Double(360/count), offset: o)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .environmentObject(mainViewModel)
    }
}

struct PieSlice: View {
    
    // MARK: - Declaring Variables
    var angle: Double = 0.0
    var offset: Int = 0
    
    // MARK: - Drawing Pie Slice
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let radius = geometry.size.width/2
                let center = CGPoint(x: radius, y: radius)
                let angleOffset = angle * Double(offset)
                path.move(to: center)
                path.addArc(center: center,
                            radius: radius,
                            startAngle: .degrees(angleOffset),
                            endAngle: .degrees(angle + angleOffset),
                            clockwise: false)
                path.closeSubpath()
            }.fill(Color(red: Double((31 * offset) % 255)/255.0,
                         green: Double((45 * offset) % 255)/255.0,
                         blue: Double((53 * offset) % 255)/255.0))
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView()
            .environmentObject(MainViewModel())
    }
}
