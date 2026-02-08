//
//  GamesListResponseModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation

struct GamesApiResponse<T: Decodable>: Decodable {
    let count: Int
    let results: T
}
