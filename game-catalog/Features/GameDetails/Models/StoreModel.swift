//
//  StoreModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.02.26.
//

import Foundation

struct StoreModel: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_background"
    }
}
