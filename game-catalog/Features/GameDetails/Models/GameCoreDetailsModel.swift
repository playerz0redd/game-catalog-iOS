//
//  GameCoreDetailsModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import Foundation

struct GameCoreDetailsModel {
    let details: GameDetailsModel
    let screenshots: [ScreenshotModel]?
    let videos: [GameVideoModel]?
    let stores: [GameInStoresModel]?
}
