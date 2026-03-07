//
//  GamesCatalogService.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation
import UIKit
import Kingfisher

protocol IGamesCatalogService {
    
    func fetchGamesList(genre: String?, search: String?) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameModel]>
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
    
    func saveGame(game: DatabaseGameModel) throws(GamesCatalogServiceError)
    func fetchGames(id: Int?) throws(GamesCatalogServiceError) -> [DatabaseGameModel]
    func deleteGame(gameId: Int) throws(GamesCatalogServiceError)
}

final class GamesCatalogService: IGamesCatalogService {
    
    private var currentPage: Int = 1
    private let networkManager: INetworkManager
    private let persistanceManager: IPersistance
    
    init(networkManager: INetworkManager, persistanceManager: IPersistance) {
        self.networkManager = networkManager
        self.persistanceManager = persistanceManager
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
            if let safeId = id {
                let predicate = #Predicate<DatabaseGameModel> {
                    $0.id == safeId
                }
                return try persistanceManager.fetch(predicat: predicate, sortBy: [])
            }
            return try persistanceManager.fetch(predicat: nil, sortBy: [])
        } catch let error {
            throw .databaseError(error)
        }
    }
    
    func saveGame(game: DatabaseGameModel) throws(GamesCatalogServiceError) {
        do {
            try persistanceManager.save(object: game)
        } catch let error {
            throw .databaseError(error)
        }
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
        search: String? = nil
    ) async throws(GamesCatalogServiceError) -> GamesApiResponse<[GameModel]> {
        do {
            let data = try await networkManager.fetch(
                url: GameApiEndpoints.listGames(page: currentPage, genre: genre, search: search).url
            )
            currentPage += 1
            return try DecodeManager.decode(data: data, as: GamesApiResponse.self)
        } catch let error as NetworkException {
            throw .networkError(error)
        } catch let error as DecoderException {
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
        } catch let error as NetworkException {
            throw .networkError(error)
        } catch let error as DecoderException {
            throw .decodingDataError(error)
        } catch let error {
            throw .unknown(error)
        }
    }
    
    
}
