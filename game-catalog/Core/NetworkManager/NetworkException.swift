//
//  NetworkException.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum NetworkException: Error {
    case urlError
    case requestError(Error)
    case serverError(code: Int)
}
