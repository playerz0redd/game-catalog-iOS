//
//  GameDetailsModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct GameDetailsModel: Decodable {
    let id: Int
    let name: String
    let originalName: String
    let description: String
    let releaseDate: Date
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "name_original"
        case description
        case releaseDate = "released"
        case imageUrl = "background_image"
    }
}
