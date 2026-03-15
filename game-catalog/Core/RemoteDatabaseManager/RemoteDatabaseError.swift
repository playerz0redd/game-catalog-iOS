//
//  RemoteDatabaseError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 14.03.26.
//

import Foundation

enum RemoteDatabaseError: Sendable, Equatable {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    
    nonisolated static func == (lhs: RemoteDatabaseError, rhs: RemoteDatabaseError) -> Bool {
        switch (lhs, rhs) {
        case (.saveError, .saveError), (.fetchError, .fetchError), (.deleteError, .deleteError): true
        default: false
        }
    }
}

extension RemoteDatabaseError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .saveError(let error):
            "Saving error: \(error.localizedDescription)"
        case .fetchError(let error):
            "Fetching error: \(error.localizedDescription)"
        case .deleteError(let error):
            "Deleting error: \(error.localizedDescription)"
        }
    }
    
    var needsRefresh: Bool {
        true
    }
    
}
