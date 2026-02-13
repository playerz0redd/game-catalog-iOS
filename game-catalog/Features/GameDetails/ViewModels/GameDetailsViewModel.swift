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
    private let gamesService: IGamesCatalogService
    @Published var player: AVPlayer?
    @Published var genres: String = ""
    @Published var isShowingVideo: Bool = false
    @Published var selectedMovie: GameVideoModel?
    @Published var isHidingToolbar = false
    
    init(gameId: Int, gamesService: IGamesCatalogService) {
        self.gamesService = gamesService
        fetchGameDetails(gameId: gameId)
        genres = getGenres
    }
    
    private var getGenres: String {
        detailsModel?.details.genres.map({ $0.name}).joined(separator: ", ") ?? ""
    }
    
    private func fetchGameDetails(gameId: Int) {
        Task(priority: .high) {
            async let details = gamesService.getGameDetails(gameId: gameId)
            async let screenshots = gamesService.getGameScreenshots(gameId: gameId)
            async let videos = gamesService.getGameVideos(gameId: gameId)
            async let gameInStores = gamesService.getGameStores(gameId: gameId)
            async let stores = gamesService.getStores()
            
            let gameDetails: GameCoreDetailsModel = .init(
                details: try await details,
                screenshots: try await screenshots.results,
                videos: try await videos.results,
                storesWithGame: try await gameInStores.results,
                stores: try await stores.results
            )
            
            await MainActor.run {
                self.detailsModel = gameDetails
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if let video = self.detailsModel?.videos?.first,
                       let highQualityVideo = video.videos.high {
                        self.player = .init(url: URL(string: highQualityVideo)!)
                        self.player?.isMuted = true
                        //self.player?.actionAtItemEnd = .advance
                        return
                    }
                    if let video = self.detailsModel?.videos?.first,
                       let lowQualityVideo = video.videos.low {
                        self.player = .init(url: URL(string: lowQualityVideo)!)
                        self.player?.isMuted = true
                        //self.player?.actionAtItemEnd = .advance
                        return
                    }
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
}

extension GameDetailsViewModel {
    
    enum ActionTypes: CaseIterable {
        case rate
        case addToLibrary
        case share
        case more
        
        var caption: LocalizedStringResource {
            switch self {
            case .rate:          "Rate"
            case .addToLibrary:  "Will play"
            case .share:         "Share"
            case .more:          "More"
            }
        }
        
        var image: String {
            switch self {
            case .rate:               "star"
            case .addToLibrary:       "plus.square.on.square"
            case .share:              "arrowshape.turn.up.right"
            case .more:               "ellipsis"
            }
        }
        
        var action: () -> Void {
            switch self {
            case .rate:
                {print("1")}
            case .addToLibrary:
                {print("2")}
            case .share:
                {print("3")}
            case .more:
                {print("4")}
            }
        }
    }
    
}
