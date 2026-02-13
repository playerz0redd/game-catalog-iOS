//
//  GameInStoresModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct GameInStoresModel: Decodable, Hashable {
    let id: Int
    let storeId: Int
    let urlToStore: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case storeId = "store_id"
        case urlToStore = "url"
    }
}
