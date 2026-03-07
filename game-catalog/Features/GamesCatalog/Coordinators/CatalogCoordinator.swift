//
//  AppCoordinator.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import SwiftUI
import Combine


final class CatalogCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    let networkManager: INetworkManager
    let gamesService: IGamesCatalogService
    
    private(set) lazy var catalogViewModel = GamesCatalogViewModel(
        gamesCatalogService: gamesService
    ) { route in
        self.push(route: route)
    }
    
    init() {
        networkManager = NetworkManager()
        gamesService = GamesCatalogService(networkManager: networkManager, persistanceManager: PersistanceManager.shared)
    }
    
    private func push(route: any IRouter) {
        self.path.append(route)
    }
    
    private func pop() {
        self.path.removeLast()
    }
    
    
    @ViewBuilder func getView(route: CatalogRouter) -> some View {
        
        switch route {
        case .catalog:
            GamesCatalogView(viewModel: catalogViewModel)
        case .details(let gameId):
            GameDetailsView(service: gamesService, gameId: gameId, onScreenPush: { route in
                self.push(route: route)
            })
        }
    }
}
