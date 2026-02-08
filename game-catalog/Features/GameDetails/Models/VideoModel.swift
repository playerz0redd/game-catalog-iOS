//
//  VideoModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct GameVideoModel: Decodable {
    let id: Int
    let name: String
    let preview: String
    let videos: VideoQualityUrls
    
    
    struct VideoQualityUrls: Decodable {
        let low: String?
        let high: String?
        
        enum CodingKeys: String, CodingKey {
            case low = "480"
            case high = "max"
        }
    }
}
