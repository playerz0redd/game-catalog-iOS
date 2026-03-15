//
//  AuthExceptions.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum AuthError: Equatable, Sendable {
    
    nonisolated static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidRegistration(Error)
    case invalidLogin(Error)
    case invalidSignOut(Error)
}

extension AuthError: IAppError {
    
    var errorDescription: LocalizedStringResource {
        switch self {
        case .invalidRegistration:
            return "Invalid registration"
        case .invalidLogin:
            return "Invalid login"
        case .invalidSignOut:
            return "Invalid sign out"
        }
    }
    
    var needsRefresh: Bool {
        switch self {
        case .invalidRegistration(let error):
            false
        case .invalidLogin(let error):
            false
        case .invalidSignOut(let error):
            false
        }
    }
}
