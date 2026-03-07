//
//  DevelopersCoordinator.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import SwiftUI
import Combine

final class DevelopersCoordinator: ObservableObject {
    @Published var path: NavigationPath = .init()
    
    func push(route: any IRouter) {
        self.path.append(route)
    }
    
    @ViewBuilder
    func getView(route: DevelopersRouter) -> some View {
        switch route {
        case .developers:
            DevelopersView(pushScreenAction: { route in
                self.push(route: route)
            })
        case .developerGames(let games):
            DeveloperGamesView(games: games, pushScreenAction: { route in
                self.push(route: route)
            })
        case .gameDetails(let gameId):
            GameDetailsView(service: GamesCatalogService(networkManager: NetworkManager(), persistanceManager: PersistanceManager.shared), gameId: gameId, onScreenPush: { route in
                self.push(route: route)
            })
        }
    }
}
