//
//  ScreenshotModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct ScreenshotModel: Decodable {
    let id: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "image"
    }
    
}
