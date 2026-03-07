//
//  DecoderException.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum DecoderException: Error {
    case decoderError(Error)
    case decodeToImageError
}
