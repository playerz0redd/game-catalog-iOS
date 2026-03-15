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
    @Published var viewState: ViewState<GamesCatalogServiceError>
    
    let onScreenPush: (FavoritesRouter) -> Void
    private let gamesService: IGamesCatalogService
    
    init(gamesService: IGamesCatalogService, onScreenPush: @escaping (FavoritesRouter) -> Void) {
        self.gamesService = gamesService
        self.onScreenPush = onScreenPush
        self.viewState = .success
        fetchFavoriteGames()
    }
    
    func fetchFavoriteGames() {
        Task {
            do {
                let databaseModels = try gamesService.fetchGames(id: nil).map({ $0.toFavoritesModel() })
                if databaseModels.isEmpty {
                    let remoteModels = try await gamesService.fetchGamesFromRemote()
                    if remoteModels.isEmpty {
                        await MainActor.run {
                            self.favoriteGames = []
                        }
                    } else {
                        await MainActor.run {
                            self.viewState = .loading
                        }
                        let favorites = try await withThrowingTaskGroup(of: FavoriteModel.self) { group in
                            for model in remoteModels {
                                group.addTask {
                                    let image = try await self.gamesService.fetchImage(url: model.imagePath)
                                    return await model.toFavoritesModel(image: image)
                                }
                            }
                            var results: [FavoriteModel] = []
                            
                            for try await favorite in group {
                                results.append(favorite)
                            }
                            
                            return results
                            
                        }
                        
                        await MainActor.run {
                            self.favoriteGames = favorites
                        }
                    }
                } else {
                    self.favoriteGames = databaseModels
                }
                await MainActor.run {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.viewState = .success
                    }
                }
            } catch let error as GamesCatalogServiceError {
                viewState = .error(error)
            }
        }
    }
    
    func onLikeAction(game: FavoriteModel) {
        game.isLiked ? dislikeGame(gameId: game.id) : likeGame(game: game)
    }
    
    func likeGame(game: FavoriteModel) {
        Task {
            do {
                try await gamesService.saveGame(game: .init(id: game.id, name: game.name, backgroundImage: game.imagePath))
            } catch let error as GamesCatalogServiceError {
                await MainActor.run {
                    viewState = .error(error)
                }
            }
        }
    }
    
    func dislikeGame(gameId: Int) {
        if let index = favoriteGames.firstIndex(where: { $0.id == gameId }) {
            favoriteGames.remove(at: index)
            Task {
                do {
                    try gamesService.deleteGame(gameId: gameId)
                    try await gamesService.deleteGameFromRemote(gameId: gameId)
                } catch let error as GamesCatalogServiceError {
                    viewState = .error(error)
                }
            }
        }
    }
}
