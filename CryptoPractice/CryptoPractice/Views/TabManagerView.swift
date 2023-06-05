//
//  TabManagerView.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import SwiftUI

struct TabManagerView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Image(systemName: "house.fill") }
            SearchView()
                .tabItem { Image(systemName: "magnifyingglass") }
            FavoriteView()
                .tabItem { Image(systemName: "heart.fill") }
        }
        .environmentObject(viewModel)
    }
}

struct TabManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TabManagerView()
    }
}
