//
//  GameModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation

struct GameModel: Decodable {
    let id: Int
    let name: String
    let realeaseDate: Date
    let backgroundImage: String
    let rating: Double
    let metacriticRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case realeaseDate = "released"
        case backgroundImage = "background_image"
        case rating
        case metacriticRating = "metacritic"
    }
    
}
