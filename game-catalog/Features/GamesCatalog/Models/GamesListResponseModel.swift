//
//  GamesListResponseModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation

struct GamesListResponseModel: Decodable {
    let count: Int
    let games: [GameModel]
    
    enum CodingKeys: String, CodingKey {
        case count
        case games = "results"
    }
}
