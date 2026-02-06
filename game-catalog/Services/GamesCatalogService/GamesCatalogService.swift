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
    
    func fetchGamesList(genre: String?) async throws -> GamesApiResponse<[GameModel]>
    func prefetchImages(urls: [String])
    func clearCache()
    func getGenres() async throws -> GamesApiResponse<[GenreModel]>
    
}

final class GamesCatalogService: IGamesCatalogService {
    
    private var currentPage: Int = 1
    private let networkManager: INetworkManager
    private let cachingManager: ICacheManager
    
    init(networkManager: INetworkManager, cachingManager: ICacheManager) {
        self.networkManager = networkManager
        self.cachingManager = cachingManager
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
    
    func fetchGamesList(genre: String? = nil) async throws -> GamesApiResponse<[GameModel]> {
        do {
            let data = try await networkManager.fetch(
                url: ListGamesEndpoints.listGames(page: currentPage, genre: genre).url
            )
            currentPage += 1
            return try DecodeManager.decode(data: data, as: GamesApiResponse.self)
        } catch let error {
            throw error
        }
    }
    
    func getGenres() async throws -> GamesApiResponse<[GenreModel]> {
        do {
            let data = try await networkManager.fetch(url: ListGamesEndpoints.genres(page: 1).url)
            return try DecodeManager.decode(data: data, as: GamesApiResponse<[GenreModel]>.self)
        } catch let error {
            throw error
        }
    }
    
    
}
