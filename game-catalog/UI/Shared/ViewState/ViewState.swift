//
//  ViewState.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.03.26.
//

import Foundation

enum ViewState<T: IAppError>: Equatable {
    case loading
    case error(T)
    case success
}
