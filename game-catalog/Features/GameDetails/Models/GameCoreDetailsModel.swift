//
//  GameCoreDetailsModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

protocol IDataList: Identifiable, Hashable {
    var id: Int { get }
    var imageUrl: String { get }
    var title: String { get }
    var isVideo: Bool { get }
    var videoUrl: String { get }
    var action: () -> Void { get }
}

struct GameCoreDetailsModel {
    let details: GameDetailsModel
    let screenshots: [ScreenshotModel]?
    let videos: [GameVideoModel]?
    let storesWithGame: [GameInStoresModel]?
    let stores: [StoreModel]
    let developers: [CreatorModel]
}
