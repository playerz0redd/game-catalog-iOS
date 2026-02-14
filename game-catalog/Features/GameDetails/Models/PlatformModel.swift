//
//  PlatformModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 14.02.26.
//

import Foundation

struct PlatformModel: Decodable, Hashable {
    let platform: Platfrom
    
    struct Platfrom: Decodable, Identifiable, Hashable {
        let id: Int
        let name: String
    }
}
