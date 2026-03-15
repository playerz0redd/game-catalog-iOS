//
//  FavoriteGameRemoteDatabaseModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 14.03.26.
//

import Foundation
import FirebaseFirestore

struct FavoriteGameRemoteDatabaseModel: Codable, Identifiable {
    let id: Int
    let name: String
    let imagePath: String
}

extension FavoriteGameRemoteDatabaseModel {
    
    init(from model: FavoriteModel) {
        self.id = model.id
        self.name = model.name
        self.imagePath = model.imagePath
    }
    
    init(from model: GameDetailsModel) {
        self.id = model.id
        self.name = model.name
        self.imagePath = model.imageUrl
    }
    
    func toFavoritesModel(image: Data) -> FavoriteModel {
        .init(id: self.id, name: self.name, image: image, imagePath: self.imagePath)
    }
}
