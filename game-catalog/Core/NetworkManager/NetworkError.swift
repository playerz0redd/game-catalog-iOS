//
//  NetworkException.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum NetworkError: Equatable, Sendable {
    
    nonisolated static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.urlError, .urlError), (.requestError, .requestError), (.serverError, .serverError): true
        default: false
        }
    }
    
    case urlError
    case requestError(Error)
    case serverError(code: Int)
}

extension NetworkError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .urlError:                      "Server url error"
        case .requestError(let error):       "Error requesting server: \(error.localizedDescription)"
        case .serverError(let code):         "Server error with code \(code)"
        }
    }
    
    var needsRefresh: Bool {
        true
    }
    
    
}
