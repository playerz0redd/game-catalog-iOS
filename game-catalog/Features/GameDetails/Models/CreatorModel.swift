//
//  CreatorModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 18.02.26.
//

import Foundation

struct CreatorModel: Decodable, Hashable {
    let id: Int
    let name: String
    let image: String?
}

extension CreatorModel: IDataList {
    var imageUrl: String {
        image ?? ""
    }
    
    var title: String {
        name
    }
    
    var action: () -> Void {
        {}
    }
    
    var isVideo: Bool {
        false
    }
    
    var videoUrl: String {
        ""
    }
    
    
}
