//
//  GamesCatalogServiceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum GamesCatalogServiceError: Error {
    case databaseError(PersistanceError)
    case networkError(NetworkException)
    case decodingDataError(DecoderException)
    case unknown(Error)
}
