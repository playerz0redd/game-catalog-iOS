//
//  MoviePlayerView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.02.26.
//

import SwiftUI
import AVKit

struct MoviePlayerView: View {
    private let movieUrl: URL
    private let player: AVPlayer
    
    init(movieUrl: URL) {
        self.movieUrl = movieUrl
        self.player = .init(url: movieUrl)
    }
    
    var body: some View {
        
        VideoPlayer(player: player)
            .aspectRatio(16/9, contentMode: .fit)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}
