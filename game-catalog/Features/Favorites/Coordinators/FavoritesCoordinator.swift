//
//  FavoritesCoordinator.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 28.02.26.
//

import Foundation
import Combine
import SwiftUI

final class FavoritesCoordinator: ObservableObject {
    @Published var path: NavigationPath = .init()
    private let gamesService: IGamesCatalogService
    private let networkManager: INetworkManager
    private let persistanseManager: IPersistance
    
    init() {
        self.networkManager = NetworkManager()
        self.persistanseManager = PersistanceManager.shared
        self.gamesService = GamesCatalogService(networkManager: networkManager, persistanceManager: persistanseManager)
    }
    
    func push(route: any IRouter) {
        path.append(route)
    }
    
    @ViewBuilder
    func getView(route: FavoritesRouter) -> some View {
        switch route {
        case .favoritesList:
            FavoritesView(viewModel: .init(gamesService: gamesService, onScreenPush: { route in
                self.push(route: route)
            }))
        case .gameDescription(let gameId):
            GameDetailsView(service: gamesService, gameId: gameId, onScreenPush: { route in
                self.push(route: route)
            })
        }
    }
}
