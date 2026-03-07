//
//  FavoritesRouter.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 28.02.26.
//

import Foundation

enum FavoritesRouter: Hashable, IRouter {
    case favoritesList
    case gameDescription(gameId: Int)
}
