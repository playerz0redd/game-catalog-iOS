//
//  AuthServiceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum AuthServiceError: Error {
    case registrationError(AuthExceptions)
    case singInError(AuthExceptions)
    case signOutError(AuthExceptions)
}
