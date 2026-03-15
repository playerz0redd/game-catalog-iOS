//
//  GamesCatalogService.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseAuth

protocol IGamesCatalogService {
    
    func fetchGamesList(genre: String?, search: String?, page: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameModel]>
    func prefetchImages(urls: [String])
    func clearCache()
    func getGenres() async throws(GamesCatalogServiceError) -> GamesApiResponse<[GenreModel]>
    func getGameDetails(gameId: Int) async throws(GamesCatalogServiceError) -> GameDetailsModel
    func getGameStores(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameInStoresModel]?>
    func getGameVideos(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameVideoModel]?>
    func getGameScreenshots(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[ScreenshotModel]?>
    func getStores() async throws(GamesCatalogServiceError) -> GamesApiResponse<[StoreModel]>
    func getCreators(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[CreatorModel]>
    func getDevelopers(page: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[DeveloperModel]>
    func fetchImage(url: String) async throws(GamesCatalogServiceError) -> Data
    
    func saveGame(game: GameModel) async throws(GamesCatalogServiceError)
    func fetchGames(id: Int?) throws(GamesCatalogServiceError) -> [DatabaseGameModel]
    func deleteGame(gameId: Int) throws(GamesCatalogServiceError)
    
    func deleteGameFromRemote(gameId: Int) async throws(GamesCatalogServiceError)
    func fetchGamesFromRemote() async throws(GamesCatalogServiceError) -> [FavoriteGameRemoteDatabaseModel]
    func saveGameToRemote(gameModel: FavoriteGameRemoteDatabaseModel) throws(GamesCatalogServiceError)
}

final class GamesCatalogService: IGamesCatalogService {
    
    private let networkManager: INetworkManager
    private let persistanceManager: IPersistance
    private let remoteDatabaseProvider: IRemoteDataProvider
    private let authManager: IAuthManager
    
    init(dependency: Dependency) {
        self.networkManager = dependency.networkManager
        self.persistanceManager = dependency.persistanceManager
        self.authManager = dependency.authManager
        self.remoteDatabaseProvider = dependency.remoteDatabaseProvider
    }
    
    func deleteGame(gameId: Int) throws(GamesCatalogServiceError) {
        let predicate = #Predicate<DatabaseGameModel> {
            $0.id == gameId
        }
        
        do {
            try persistanceManager.delete(predicate: predicate)
        } catch let error {
            throw .databaseError(error)
        }
    }
    
    func fetchImage(url: String) async throws(GamesCatalogServiceError) -> Data {
        do {
            return try await networkManager.fetch(url: URL(string: url))
        } catch let error {
            throw .networkError(error)
        }
    }
    
    func fetchGames(id: Int?) throws(GamesCatalogServiceError) -> [DatabaseGameModel] {
        do {
            let uid = authManager.getUser?.uid ?? "no id"
            
            if let safeId = id {
                let predicate = #Predicate<DatabaseGameModel> {
                    $0.id == safeId && $0.uid == uid
                }
                return try persistanceManager.fetch(predicat: predicate, sortBy: [])
            }
            
            let predicate = #Predicate<DatabaseGameModel> {
                $0.uid == uid
            }
            
            return try persistanceManager.fetch(predicat: predicate, sortBy: [])
        } catch let error {
            throw .databaseError(error)
        }
    }
    
    func saveGame(game: GameModel) async throws(GamesCatalogServiceError) {
        do {
            let uid = authManager.getUser?.uid ?? "no id"
            
            let game = DatabaseGameModel(id: game.id, name: game.name, image: try await fetchImage(url: game.backgroundImage!), imagePath: game.backgroundImage!, uid: uid)
            
            try persistanceManager.save(object: game)
        } catch let error as PersistanceError {
            throw .databaseError(error)
        } catch let error {
            throw .unknown(error)
        }
    }
    
    func saveGameToRemote(gameModel: FavoriteGameRemoteDatabaseModel) throws(GamesCatalogServiceError) {
        do {
            let path = configurePath(category: .favorites)
            try remoteDatabaseProvider.save(object: gameModel, path: path)
        } catch let error {
            throw .remoteDatabaseError(error)
        }
    }
    
    func deleteGameFromRemote(gameId: Int) async throws(GamesCatalogServiceError) {
        do {
            let path = configurePath(category: .favorites)
            try await remoteDatabaseProvider.delete(path: path, id: String(gameId))
        } catch let error {
            throw .remoteDatabaseError(error)
        }
    }
    
    func fetchGamesFromRemote() async throws(GamesCatalogServiceError) -> [FavoriteGameRemoteDatabaseModel] {
        do {
            let path = configurePath(category: .favorites)
            return try await remoteDatabaseProvider.fetchAll(path: path)
        } catch let error {
            throw .remoteDatabaseError(error)
        }
    }
    
    private func configurePath(category: RemoteDatabaseDataCategory) -> String {
        let uid = authManager.getUser?.uid ?? "uid"
        return "users/\(uid)/\(category.path)"
    }
    
    func prefetchImages(urls: [String]) {
        let kfUrls = urls.compactMap( { URL(string: $0)} )
        let prefetcher = ImagePrefetcher(urls: kfUrls)
        prefetcher.start()
    }
    
    func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
    
    func fetchGamesList(
        genre: String? = nil,
        search: String? = nil,
        page: Int
    ) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameModel]> {
        do {
            let data = try await networkManager.fetch(
                url: GameApiEndpoints.listGames(page: page, genre: genre, search: search).url
            )
            return try DecodeManager.decode(data: data, as: GamesApiResponse.self)
        } catch let error as NetworkError {
            throw .networkError(error)
        } catch let error as DecoderError {
            throw .decodingDataError(error)
        } catch let error {
            throw .unknown(error)
        }
    }
    
    func getGenres() async throws(GamesCatalogServiceError) -> GamesApiResponse<[GenreModel]> {
        try await performApiRequest(endpoint: GameApiEndpoints.genres(page: 1), type: GamesApiResponse<[GenreModel]>.self)
    }
    
    func getCreators(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[CreatorModel]> {
        try await performApiRequest(endpoint: GameApiEndpoints.creators(gameId: gameId), type: GamesApiResponse<[CreatorModel]>.self)
    }
    
    func getGameDetails(gameId: Int) async throws(GamesCatalogServiceError) -> GameDetailsModel {
        try await performApiRequest(endpoint: GameApiEndpoints.gameDetails(gameId: gameId), type: GameDetailsModel.self)
    }
    
    func getGameStores(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameInStoresModel]?> {
        try await performApiRequest(endpoint: GameApiEndpoints.gameStores(gameId: gameId), type: GamesApiResponse<[GameInStoresModel]?>.self)
    }
    
    func getGameVideos(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameVideoModel]?> {
        try await performApiRequest(endpoint: GameApiEndpoints.gameVideos(gameId: gameId), type: GamesApiResponse<[GameVideoModel]?>.self)
    }
    
    func getGameScreenshots(gameId: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[ScreenshotModel]?> {
        try await performApiRequest(endpoint: GameApiEndpoints.gameScreenshots(gameId: gameId), type: GamesApiResponse<[ScreenshotModel]?>.self)
    }
    
    func getStores() async throws(GamesCatalogServiceError) -> GamesApiResponse<[StoreModel]> {
        try await performApiRequest(endpoint: GameApiEndpoints.stores, type: GamesApiResponse<[StoreModel]>.self)
    }
    
    func getDevelopers(page: Int) async throws(GamesCatalogServiceError) -> GamesApiResponse<[DeveloperModel]> {
        try await performApiRequest(endpoint: GameApiEndpoints.developers(page: page), type: GamesApiResponse<[DeveloperModel]>.self)
    }
    
    private func performApiRequest<T: Decodable>(endpoint: GameApiEndpoints, type: T.Type) async throws(GamesCatalogServiceError) -> T {
        do {
            let data = try await networkManager.fetch(url: endpoint.url)
            return try DecodeManager.decode(data: data, as: type.self)
        } catch let error as NetworkError {
            throw .networkError(error)
        } catch let error as DecoderError {
            throw .decodingDataError(error)
        } catch let error {
            throw .unknown(error)
        }
    }
    
    
}

extension GamesCatalogService {
    
    struct Dependency {
        let networkManager: INetworkManager
        let persistanceManager: IPersistance
        let authManager: IAuthManager
        let remoteDatabaseProvider: IRemoteDataProvider
    }
    
    enum RemoteDatabaseDataCategory {
        case favorites
        
        var path: String {
            switch self {
            case .favorites:
                "favorites/"
            }
        }
    }
    
}
