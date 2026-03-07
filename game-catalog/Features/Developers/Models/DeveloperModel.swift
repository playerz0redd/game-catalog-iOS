//
//  DeveloperModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 26.02.26.
//

import Foundation

struct DeveloperModel: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let games: [GameModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "image_background"
        case games
    }
    
    struct GameModel: Decodable, Hashable {
        let id: Int
        let name: String
    }
}
