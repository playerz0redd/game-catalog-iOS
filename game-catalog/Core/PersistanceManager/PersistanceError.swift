//
//  PersistanceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum PersistanceError: Error {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
}
