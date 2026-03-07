//
//  AuthExceptions.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum AuthExceptions: Error {
    case invalidRegistration(Error)
    case invalidLogin(Error)
    case invalidSignOut(Error)
}
