//
//  FavoritesViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteGames: [FavoriteModel] = []
    
    let onScreenPush: (FavoritesRouter) -> Void
    private let gamesService: IGamesCatalogService
    
    init(gamesService: IGamesCatalogService, onScreenPush: @escaping (FavoritesRouter) -> Void) {
        self.gamesService = gamesService
        self.onScreenPush = onScreenPush
        fetchFavoriteGames()
    }
    
    func fetchFavoriteGames() {
        do {
            self.favoriteGames = try gamesService.fetchGames(id: nil).map({ $0.toFavoritesModel() })
        } catch let error {
            print(error)
        }
    }
    
    func onLikeAction(game: FavoriteModel) {
        game.isLiked ? dislikeGame(gameId: game.id) : likeGame(game: game)
    }
    
    func likeGame(game: FavoriteModel) {
        try? gamesService.saveGame(game: .init(id: game.id, name: game.name, image: game.image))
    }
    
    func dislikeGame(gameId: Int) {
        try? gamesService.deleteGame(gameId: gameId)
    }
}
