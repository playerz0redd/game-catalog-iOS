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
    
    init(id: Int, name: String, image: Data) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    init(from: GameDetailsModel, image: Data) {
        self.id = from.id
        self.name = from.name
        self.image = image
    }
}

extension DatabaseGameModel {
    func toFavoritesModel() -> FavoriteModel {
        .init(id: self.id, name: self.name, image: self.image)
    }
}
