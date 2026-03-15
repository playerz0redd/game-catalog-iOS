//
//  GameModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation

struct GameModel: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    var realeaseDate: Date?
    var backgroundImage: String?
    var rating: Double?
    var metacriticRating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case realeaseDate = "released"
        case backgroundImage = "background_image"
        case rating
        case metacriticRating = "metacritic"
    }
    
}
