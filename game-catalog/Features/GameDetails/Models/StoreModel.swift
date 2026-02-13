//
//  StoreModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.02.26.
//

import Foundation

struct StoreModel: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_background"
    }
}

extension StoreModel {
    
    enum Stores: Int {
        case steam = 1
        case playstation = 3
        case xbox = 2
        case appstore = 4
        case gog = 5
        case nintendo = 6
        case xbox360 = 7
        case googleplay = 8
        case itch = 9
        case epicgames = 11
        
        var icon: String {
            switch self {
            case .steam:
                "steam-icon"
            case .playstation:
                "ps-store-icon"
            case .xbox:
                "xbox-icon"
            case .appstore:
                "app-store-icon"
            case .gog:
                "gog-icon"
            case .nintendo:
                "nintendo-icon"
            case .xbox360:
                "xbox-360-icon"
            case .googleplay:
                "google-icon"
            case .itch:
                "itch-icon"
            case .epicgames:
                "epic-games-icon"
            }
        }
    }
}
