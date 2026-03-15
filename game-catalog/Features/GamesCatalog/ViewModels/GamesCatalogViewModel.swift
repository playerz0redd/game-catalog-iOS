//
//  GamesCatalogViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation
import Combine
import UIKit

final class GamesCatalogViewModel: ObservableObject {
    
    @Published var games: [GameModel] = []
    @Published var isLoading = false
    @Published var isShowingGenres = false
    @Published var genres: [GenreModel] = []
    @Published var selectedGenre: String?
    @Published var isHeaderVisible: Bool = true
    @Published var searchText: String = ""
    @Published var viewState: ViewState<GamesCatalogServiceError>
    
    let gamesCatalogService: IGamesCatalogService
    let onScreenPush: (any IRouter) -> Void
    
    private var currentPage = 1
    
    init(gamesCatalogService: IGamesCatalogService, onScreenPush: @escaping (any IRouter) -> Void) {
        self.gamesCatalogService = gamesCatalogService
        self.onScreenPush = onScreenPush
        self.viewState = .loading
        loadMoreGames()
        getGenres()
    }
    
    func loadMoreGames() {
        self.isHeaderVisible = true
        Task(priority: .userInitiated) {
            do {
                let response = try await gamesCatalogService.fetchGamesList(
                    genre: selectedGenre,
                    search: searchText == "" ? nil : searchText,
                    page: currentPage
                )
                
                let newGames = response.results
                
                let urls = newGames.compactMap({ $0.backgroundImage })
                
                gamesCatalogService.prefetchImages(urls: urls)
                
                await MainActor.run {
                    self.games += newGames
                    currentPage += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.viewState = .success
                    }
                }
            } catch let error as GamesCatalogServiceError {
                viewState = .error(error)
            }
        }
    }
    
    func onGenreButtonClick() {
        if selectedGenre != nil {
            selectedGenre = nil
            self.viewState = .loading
            currentPage = 1
            games = []
            loadMoreGames()
        } else {
            isShowingGenres = true
        }
    }
    
    func findGameBySearch() {
        games = []
        self.viewState = .loading
        currentPage = 1
        loadMoreGames()
    }
    
    func getGenres() {
        Task {
            do {
                let response = try await gamesCatalogService.getGenres()
                self.genres = response.results
                
            } catch let error as GamesCatalogServiceError {
                viewState = .error(error)
            }
        }
    }

    func onGenreSelect(genre: String) {
        selectedGenre = genre
        games = []
        currentPage = 1
        loadMoreGames()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.isShowingGenres = false
            self.viewState = .loading
        }
    }
}
