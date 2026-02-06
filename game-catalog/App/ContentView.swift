//
//  ContentView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GamesCatalogView(viewModel: .init(gamesCatalogService: GamesCatalogService(networkManager: NetworkManager())))
                .navigationTitle(Text("Game List"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
