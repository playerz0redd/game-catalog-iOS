//
//  FavoriteModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import Foundation

struct FavoriteModel: Hashable {
    let id: Int
    let name: String
    let image: Data
    var isLiked: Bool = true
}
