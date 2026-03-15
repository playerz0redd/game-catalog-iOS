//
//  StorageError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum DataStorageError: Equatable, Sendable {
    
    nonisolated static func == (lhs: DataStorageError, rhs: DataStorageError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case saveError(Error)
    case deleteError(Error)
}

extension DataStorageError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .saveError(let error):
            "Error saving: \(error.localizedDescription)"
        case .deleteError(let error):
            "Error deleting: \(error.localizedDescription)"
        }
    }
    
    var needsRefresh: Bool {
        true
    }
    
    
}
