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
    
    func fetchGamesList(genre: String?, search: String?) async throws -> GamesApiResponse<[GameModel]>
    func prefetchImages(urls: [String])
    func clearCache()
    func getGenres() async throws -> GamesApiResponse<[GenreModel]>
    func getGameDetails(gameId: Int) async throws -> GameDetailsModel
    func getGameStores(gameId: Int) async throws -> GamesApiResponse<[GameInStoresModel]?>
    func getGameVideos(gameId: Int) async throws -> GamesApiResponse<[GameVideoModel]?>
    func getGameScreenshots(gameId: Int) async throws -> GamesApiResponse<[ScreenshotModel]?> 
    
}

final class GamesCatalogService: IGamesCatalogService {
    
    private var currentPage: Int = 1
    private let networkManager: INetworkManager
    
    init(networkManager: INetworkManager) {
        self.networkManager = networkManager
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
    ) async throws -> GamesApiResponse<[GameModel]> {
        do {
            let data = try await networkManager.fetch(
                url: GameApiEndpoints.listGames(page: currentPage, genre: genre, search: search).url
            )
            currentPage += 1
            return try DecodeManager.decode(data: data, as: GamesApiResponse.self)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getGenres() async throws -> GamesApiResponse<[GenreModel]> {
        try await performApiRequest(endpoint: GameApiEndpoints.genres(page: 1), type: GamesApiResponse<[GenreModel]>.self)
    }
    
    func getGameDetails(gameId: Int) async throws -> GameDetailsModel {
        try await performApiRequest(endpoint: GameApiEndpoints.gameDetails(gameId: gameId), type: GameDetailsModel.self)
    }
    
    func getGameStores(gameId: Int) async throws -> GamesApiResponse<[GameInStoresModel]?> {
        try await performApiRequest(endpoint: GameApiEndpoints.gameStores(gameId: gameId), type: GamesApiResponse<[GameInStoresModel]?>.self)
    }
    
    func getGameVideos(gameId: Int) async throws -> GamesApiResponse<[GameVideoModel]?> {
        try await performApiRequest(endpoint: GameApiEndpoints.gameVideos(gameId: gameId), type: GamesApiResponse<[GameVideoModel]?>.self)
    }
    
    func getGameScreenshots(gameId: Int) async throws -> GamesApiResponse<[ScreenshotModel]?> {
        try await performApiRequest(endpoint: GameApiEndpoints.gameScreenshots(gameId: gameId), type: GamesApiResponse<[ScreenshotModel]?>.self)
    }
    
    private func performApiRequest<T: Decodable>(endpoint: GameApiEndpoints, type: T.Type) async throws -> T {
        do {
            let data = try await networkManager.fetch(url: endpoint.url)
            return try DecodeManager.decode(data: data, as: type.self)
        } catch let error {
            throw error
        }
    }
    
    
}
