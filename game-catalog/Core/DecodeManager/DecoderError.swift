//
//  DecoderException.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum DecoderError: Equatable, Sendable {
    
    nonisolated static func == (lhs: DecoderError, rhs: DecoderError) -> Bool {
        switch (lhs, rhs) {
        case (.decoderError, .decoderError), (.decodeToImageError, .decodeToImageError): true
        default: false
        }
    }
    
    case decoderError(reason: String)
    case decodeToImageError
}

extension DecoderError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .decoderError(let reason):
            "Error parsing data: \(reason)"
        case .decodeToImageError:
            "Error parsing image"
        }
    }
    
    var needsRefresh: Bool {
        false
    }
    
    
}
