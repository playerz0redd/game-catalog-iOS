//
//  CatalogRouter.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 2.03.26.
//

import Foundation

enum CatalogRouter: Hashable, IRouter {
    case catalog
    case details(gameId: Int)
    
}
