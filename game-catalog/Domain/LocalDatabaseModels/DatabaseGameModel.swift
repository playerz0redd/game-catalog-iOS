//
//  DatabaseGameModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import Foundation
import SwiftData

@Model
class DatabaseGameModel {
    var id: Int
    var name: String
    @Attribute(.externalStorage) var image: Data
    var imagePath: String
    var uid: String
    
    init(id: Int, name: String, image: Data, imagePath: String, uid: String) {
        self.id = id
        self.name = name
        self.image = image
        self.imagePath = imagePath
        self.uid = uid
    }
    
    init(from: GameDetailsModel, image: Data, uid: String) {
        self.id = from.id
        self.name = from.name
        self.image = image
        self.imagePath = from.imageUrl
        self.uid = uid
    }
}

extension DatabaseGameModel {
    func toFavoritesModel() -> FavoriteModel {
        .init(id: self.id, name: self.name, image: self.image, imagePath: self.imagePath)
    }
}
