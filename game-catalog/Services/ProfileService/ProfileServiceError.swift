//
//  ProfileServiceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 10.03.26.
//

import Foundation

enum ProfileServiceError: Error {
    case storageError(DataStorageError)
    case authError(AuthExceptions)
}
