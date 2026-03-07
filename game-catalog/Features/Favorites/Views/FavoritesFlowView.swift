//
//  FavoritesFlowView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 28.02.26.
//

import Foundation
import SwiftUI

struct FavoritesFlowView: View {
    @StateObject private var coordinator: FavoritesCoordinator = .init()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.getView(route: .favoritesList)
                .navigationDestination(for: FavoritesRouter.self) { route in
                    coordinator.getView(route: route)
                }
                .navigationDestination(for: DetailsRouter.self) { route in
                    route.getView()
                }
        }
    }
}
