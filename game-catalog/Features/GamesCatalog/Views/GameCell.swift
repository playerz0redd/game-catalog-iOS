//
//  GameCell.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI
import Kingfisher

struct GameCell: View {
    
    private let game: GameModel
    
    init(game: GameModel) {
        self.game = game
    }
    
    var body: some View {

        VStack(alignment: .leading, spacing: 8) {
            imageView
            
            textLabel
        }
        
    }
}

private extension GameCell {
    
    var imageView: some View {
        Color.gray.opacity(0.3)
            .aspectRatio(1, contentMode: .fill)
            .overlay(
                KFImage(URL(string: game.backgroundImage ?? ""))
                    .placeholder { ProgressView() }
                    .onFailure { error in print("Ошибка: \(error)") }
                    .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 400, height: 400)))
                    .cacheMemoryOnly(false)
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()
            )
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var textLabel: some View {
        Text(game.name)
            .font(.caption)
            .fontWeight(.medium)
            .lineLimit(1)
    }
}

