//
//  DevelopersRouter.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import Foundation

enum DevelopersRouter: Hashable, IRouter {
    case developers
    case developerGames(games: [DeveloperModel.GameModel])
    case gameDetails(gameId: Int)
}
