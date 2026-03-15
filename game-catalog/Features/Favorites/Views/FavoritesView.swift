//
//  FavoritesView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .loading:
                FavoritesViewSceleton()
                    .transition(.opacity)
            case .error(let error):
                Text(error.errorDescription)
                    .transition(.opacity)
            case .success:
                if viewModel.favoriteGames.isEmpty {
                    ContentUnavailableView("Nothing Was Found", systemImage: "tray", description: Text("Add some games to favorites"))
                        .transition(.opacity)
                } else {
                    favoritesView
                        .transition(.opacity)
                }
            }
        }
        .animation(.bouncy, value: viewModel.viewState)
        .animation(.bouncy, value: viewModel.favoriteGames)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Favorites")
        .padding(.horizontal, 5)
        .onAppear {
            viewModel.fetchFavoriteGames()
        }
    }
}

private extension FavoritesView {
    var favoritesView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach($viewModel.favoriteGames, id: \.self) { game in
                    gameView(game: game)
                        .onTapGesture {
                            viewModel.onScreenPush(.gameDescription(gameId: game.wrappedValue.id))
                        }
                }
            }
        }
    }
}

private extension FavoritesView {
    func gameView(game: Binding<FavoriteModel>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            
            GameImage(data: game.wrappedValue.image)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: game.wrappedValue.isLiked ? "heart.fill" : "heart")
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(game.wrappedValue.isLiked ? .red : .gray)
                        .font(.system(size: 42))
                        .onTapGesture {
                            viewModel.onLikeAction(game: game.wrappedValue)
                        }
                        .padding(.top, 15)
                        .padding(.trailing, 15)
                }
            
            Text(game.wrappedValue.name)
                .font(.system(size: 24, weight: .semibold))
        }
    }
}

private extension FavoritesView {
    struct GameImage: View {
        let data: Data
        
        private var image: UIImage? {
            .init(data: data)
        }
        
        var body: some View {
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(16/9, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
