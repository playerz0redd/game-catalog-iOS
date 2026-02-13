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
    
    let gamesCatalogService: IGamesCatalogService
    var coordinator: AppCoordinator?
    
    init(gamesCatalogService: IGamesCatalogService) {
        self.gamesCatalogService = gamesCatalogService
        loadMoreGames()
        getGenres()
    }
    
    func loadMoreGames() {
        guard !isLoading else { return }
        isLoading = true
        
        Task(priority: .userInitiated) {
            let response = try await gamesCatalogService.fetchGamesList(
                genre: selectedGenre,
                search: searchText == "" ? nil : searchText
            )
            
            let newGames = response.results
            
            let urls = newGames.compactMap({ $0.backgroundImage })
            
            gamesCatalogService.prefetchImages(urls: urls)
            
            await MainActor.run {
                self.games += newGames
                isLoading = false
            }
        }
    }
    
    func onGenreButtonClick() {
        if selectedGenre != nil {
            selectedGenre = nil
            games = []
            loadMoreGames()
        } else {
            isShowingGenres = true
        }
    }
    
    func findGameBySearch() {
        games = []
        loadMoreGames()
    }
    
    func getGenres() {
        Task {
            let response = try await gamesCatalogService.getGenres()
            self.genres = response.results
        }
    }

    func onGenreSelect(genre: String) {
        selectedGenre = genre
        games = []
        loadMoreGames()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.isShowingGenres = false
        }
    }
}
