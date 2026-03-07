//
//  StorageError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum DataStorageError: Error {
    case saveError(Error)
    case deleteError(Error)
}
