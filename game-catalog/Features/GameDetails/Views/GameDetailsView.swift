//
//  GameDetailsView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import SwiftUI
import Kingfisher

struct GameDetailsView: View {
    
    @ObservedObject private var viewModel: GameDetailsViewModel
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            gameImage
        }
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension GameDetailsView {
    
    @ViewBuilder var gameImage: some View {
            KFImage(URL(string: viewModel.detailsModel?.details.imageUrl ?? ""))
                .placeholder { ProgressView() }
                .onFailure { error in print("Ошибка: \(error)") }
                .cacheMemoryOnly(false)
                .fade(duration: 0.25)
                .resizable()
                .scaledToFit()
            //.frame(width: 300, height: 800)
    }
    
}
