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
    private let dismiss: () -> Void
    @State private var offset: CGSize = .zero
    @State private var opacity: CGFloat = 1
    
    init(movieUrl: URL, dismiss: @escaping () -> Void) {
        self.movieUrl = movieUrl
        self.dismiss = dismiss
        self.player = .init(url: movieUrl)
    }
    
    var body: some View {
        ZStack {
            
            Color.black
            
            VideoPlayer(player: player)
                .offset(offset)
                .aspectRatio(16/9, contentMode: .fit)
                .onAppear {
                    player.play()
                }
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                            opacity = 1 - abs(gesture.translation.height) / (Constants.UIConstants.screenHeight / 2)
                        }
                        .onEnded { gesture in
                            if abs(gesture.translation.height) > Constants.UIConstants.screenHeight / 3 {
                                player.pause()
                                dismiss()
                            } else {
                                offset = .zero
                                opacity = 1
                            }
                        }
                )
        }
        .opacity(opacity)
        .animation(.snappy, value: offset)
        .animation(.snappy, value: opacity)
        .ignoresSafeArea()
    }
}
