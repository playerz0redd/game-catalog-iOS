//
//  GameDetailsViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation
import Combine
import AVKit

final class GameDetailsViewModel: ObservableObject {
    
    @Published var detailsModel: GameCoreDetailsModel?
    @Published var player: AVPlayer?
    @Published var genres: String = ""
    @Published var isShowingVideo: Bool = false
    @Published var selectedMovie: GameVideoModel?
    @Published var isHidingToolbar = false
    @Published var isShowingSafari = false
    @Published var isShowingViewer = false
    @Published var selectedContent: ViewerContent?
    @Published var isLiked: Bool = false
    @Published var viewState: ViewState<GamesCatalogServiceError>
    
    var safariLink: String?

    let onScreenPush: (DetailsRouter) -> Void
    private let gamesService: IGamesCatalogService
    
    
    init(gameId: Int, gamesService: IGamesCatalogService, onScreenPush: @escaping (DetailsRouter) -> Void) {
        self.gamesService = gamesService
        self.onScreenPush = onScreenPush
        self.viewState = .loading
        fetchGameDetails(gameId: gameId)
        genres = getGenres
    }
    
    lazy var storeDictionary: [GameInStoresModel:StoreModel] = {
        var dict: [GameInStoresModel:StoreModel] = [:]
        detailsModel?.storesWithGame?.forEach { storeWithGame in
            dict[storeWithGame] = detailsModel?.stores.first(where: { $0.id == storeWithGame.storeId})!
        }
        return dict
    }()
    
    private var getGenres: String {
        detailsModel?.details.genres.map({ $0.name}).joined(separator: ", ") ?? ""
    }
    
    private func fetchGameDetails(gameId: Int) {
        Task(priority: .high) {
            
            do {
                async let details = gamesService.getGameDetails(gameId: gameId)
                async let screenshots = gamesService.getGameScreenshots(gameId: gameId)
                async let videos = gamesService.getGameVideos(gameId: gameId)
                async let gameInStores = gamesService.getGameStores(gameId: gameId)
                async let stores = gamesService.getStores()
                async let developers = gamesService.getCreators(gameId: gameId)
                
                let gameDetails: GameCoreDetailsModel = .init(
                    details: try await details,
                    screenshots: try await screenshots.results,
                    videos: try await videos.results,
                    storesWithGame: try await gameInStores.results,
                    stores: try await stores.results,
                    developers: try await developers.results
                )
                
                await MainActor.run {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.viewState = .success
                    }
                    
                    self.detailsModel = gameDetails
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let video = self.detailsModel?.videos?.first,
                           let highQualityVideo = video.videos.high {
                            self.player = .init(url: URL(string: highQualityVideo)!)
                            self.player?.isMuted = true
                        }
                        else if let video = self.detailsModel?.videos?.first,
                                let lowQualityVideo = video.videos.low {
                            self.player = .init(url: URL(string: lowQualityVideo)!)
                            self.player?.isMuted = true
                        }
                    }
                    self.isLiked = isAddedToFavorites()
                }
            }
            catch let error as GamesCatalogServiceError {
                await MainActor.run {
                    self.viewState = .error(error)
                }
            }
        }
    }
    
    func onMovieShow(movie: GameVideoModel) {
        self.player?.pause()
        self.isHidingToolbar = true
        self.selectedMovie = movie
        self.isShowingVideo = true
    }
    
    func onMovieExit() {
        self.selectedMovie = nil
        self.isHidingToolbar = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.player?.play()
        }
    }
    
    func isAddedToFavorites() -> Bool {
        do {
            let games = try gamesService.fetchGames(id: self.detailsModel?.details.id)
            return games.isEmpty ? false : true
        } catch let error {
            print(error)
        }
        return false
    }
    
    func getStoreImage(storeId: Int) -> String {
        StoreModel.Stores.init(rawValue: storeId)?.icon ?? ""
    }
    
    func favoritesAction() {
        isLiked ? deleteFromFavorites() : addToFavorites()
    }
    
    func deleteFromFavorites() {
        if let gameId = self.detailsModel?.details.id {
            Task {
                do {
                    try gamesService.deleteGame(gameId: gameId)
                    try await gamesService.deleteGameFromRemote(gameId: gameId)
                }
                catch let error as GamesCatalogServiceError {
                    await MainActor.run {
                        self.viewState = .error(error)
                    }
                }
            }
        }
        isLiked = false
    }
    
    func addToFavorites() {
        Task {
            if let game = self.detailsModel?.details {
                
                let remoteModel = FavoriteGameRemoteDatabaseModel(from: game)
                do {
                    try await gamesService.saveGame(game: .init(id: game.id, name: game.name, backgroundImage: game.imageUrl))
                    try gamesService.saveGameToRemote(gameModel: remoteModel)
                }
                catch let error as GamesCatalogServiceError {
                    await MainActor.run {
                        self.viewState = .error(error)
                    }
                }
            }
        }
        isLiked = true
    }
}

extension GameDetailsViewModel {
    enum ViewerContent {
        case trailers
        case screenshots
        case developers
    }
}
