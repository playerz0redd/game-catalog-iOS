//
//  IAppError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.03.26.
//

import Foundation


protocol IAppError: LocalizedError, Equatable {
    var errorDescription: LocalizedStringResource { get }
    var needsRefresh: Bool { get }
}
