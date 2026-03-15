//
//  GamesCatalogServiceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum GamesCatalogServiceError: Equatable, Sendable {
    
    nonisolated static func ==(lhs: GamesCatalogServiceError, rhs: GamesCatalogServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.databaseError, .databaseError), (.networkError, .networkError),
            (.decodingDataError, .decodingDataError), (.remoteDatabaseError, .remoteDatabaseError), (.unknown, .unknown):
            true
        default: false
        }
    }
    
    case databaseError(PersistanceError)
    case networkError(NetworkError)
    case decodingDataError(DecoderError)
    case remoteDatabaseError(RemoteDatabaseError)
    case unknown(Error)
}

extension GamesCatalogServiceError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .databaseError(let persistanceError):       persistanceError.errorDescription
        case .networkError(let networkError):            networkError.errorDescription
        case .decodingDataError(let decoderError):       decoderError.errorDescription
        case .unknown(let error):                        "Unknown error occured: \(error.localizedDescription)"
        case .remoteDatabaseError(let error):            error.errorDescription
        }
    }
    
    var needsRefresh: Bool {
        switch self {
        case .databaseError(let persistanceError):      persistanceError.needsRefresh
        case .networkError(let networkError):           networkError.needsRefresh
        case .decodingDataError(let decoderError):      decoderError.needsRefresh
        case .unknown:                                  false
        case .remoteDatabaseError(let error):           error.needsRefresh
        }
    }
    
    
}
