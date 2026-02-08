//
//  AppCoordinator.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    private let networkManager: INetworkManager
    private let gamesService: IGamesCatalogService
    private(set) lazy var catalogViewModel = GamesCatalogViewModel(gamesCatalogService: gamesService)
    
    init() {
        networkManager = NetworkManager()
        gamesService = GamesCatalogService(networkManager: networkManager)
    }
    
    func push(route: AppRouter) {
        self.path.append(route)
    }
    
    func pop() {
        self.path.removeLast()
    }
    
    
    @ViewBuilder func getView(route: AppRouter) -> some View {
        
        switch route {
        case .catalog:
            GamesCatalogView(viewModel: catalogViewModel)
        case .details(let gameId):
            let vm = GameDetailsViewModel(gameId: gameId, gamesService: gamesService)
            GameDetailsView(viewModel: vm)
        }
    }
}
