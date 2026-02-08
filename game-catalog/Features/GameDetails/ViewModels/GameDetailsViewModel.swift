//
//  GameDetailsViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation
import Combine

final class GameDetailsViewModel: ObservableObject {
    
    @Published var detailsModel: GameCoreDetailsModel?
    private let gamesService: IGamesCatalogService
    
    init(gameId: Int, gamesService: IGamesCatalogService) {
        self.gamesService = gamesService
        fetchGameDetails(gameId: gameId)
    }
    
    private func fetchGameDetails(gameId: Int) {
        Task(priority: .high) {
            async let details = gamesService.getGameDetails(gameId: gameId)
            async let screenshots = gamesService.getGameScreenshots(gameId: gameId)
            async let videos = gamesService.getGameVideos(gameId: gameId)
            async let stores = gamesService.getGameStores(gameId: gameId)
            
            let gameDetails: GameCoreDetailsModel = .init(
                details: try await details,
                screenshots: try await screenshots.results,
                videos: try await videos.results,
                stores: try await stores.results
            )
            
            await MainActor.run {
                self.detailsModel = gameDetails
            }
        }
    }

}
