//
//  ProfileServiceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 10.03.26.
//

import Foundation

enum ProfileServiceError: Equatable, Sendable {
    
    nonisolated static func ==(lhs: ProfileServiceError, rhs: ProfileServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.storageError, .storageError), (.authError, .authError): true
        default: false
        }
    }
    
    case storageError(DataStorageError)
    case authError(AuthError)
}

extension ProfileServiceError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .storageError(let dataStorageError):    dataStorageError.errorDescription
        case .authError(let authError):              authError.errorDescription
        }
    }
    
    var needsRefresh: Bool {
        switch self {
        case .storageError(let dataStorageError):    dataStorageError.needsRefresh
        case .authError(let authError):              authError.needsRefresh
        }
    }
    
    
}
