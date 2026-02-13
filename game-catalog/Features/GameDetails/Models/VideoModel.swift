//
//  VideoModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct GameVideoModel: Decodable, Identifiable, Equatable {
    
    static func == (lhs: GameVideoModel, rhs: GameVideoModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let preview: String
    let videos: VideoQualityUrls
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case preview
        case videos = "data"
    }
    
    
    struct VideoQualityUrls: Decodable {
        let low: String?
        let high: String?
        
        enum CodingKeys: String, CodingKey {
            case low = "480"
            case high = "max"
        }
    }
}
