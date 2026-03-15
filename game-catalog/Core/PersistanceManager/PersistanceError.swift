//
//  PersistanceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum PersistanceError: Equatable, Sendable {
    
    nonisolated static func == (lhs: PersistanceError, rhs: PersistanceError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
}

extension PersistanceError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .saveError(let error):
            "Error saving data: \(error.localizedDescription)"
        case .fetchError(let error):
            "Error fetching data: \(error.localizedDescription)"
        case .deleteError(let error):
            "Error deleting data: \(error.localizedDescription)"
        }
    }
    
    var needsRefresh: Bool {
        true
    }
    
    
}
