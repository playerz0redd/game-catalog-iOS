//
//  VideoModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct GameVideoModel: Decodable, Identifiable, Hashable {
    
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
    
    
    struct VideoQualityUrls: Decodable, Hashable {
        let low: String?
        let high: String?
        
        enum CodingKeys: String, CodingKey {
            case low = "480"
            case high = "max"
        }
    }
}

extension GameVideoModel: IDataList {
    var imageUrl: String {
        preview
    }
    
    var title: String {
        name
    }
    
    var action: () -> Void {
        {}
    }
    
    var isVideo: Bool {
        true
    }
    
    var videoUrl: String {
        self.videos.high ?? self.videos.low ?? ""
    }
    
    
}
