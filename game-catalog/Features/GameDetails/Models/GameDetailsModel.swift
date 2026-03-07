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
    let rating: Double
    let genres: [GenreModel]
    let ratingsCount: Int
    let platforms: [PlatformModel]
    let ageRating: EsrbRating?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "name_original"
        case description = "description_raw"
        case releaseDate = "released"
        case imageUrl = "background_image"
        case rating
        case genres
        case ratingsCount = "ratings_count"
        case platforms
        case ageRating = "esrb_rating"
    }
    
    struct EsrbRating: Decodable {
        let id: Int
        let name: String
    }
}
