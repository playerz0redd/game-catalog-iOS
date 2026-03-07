//
//  DevelopersFlowView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import SwiftUI

struct DevelopersFlowView: View {
    
    @StateObject private var coordinator: DevelopersCoordinator = .init()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            DevelopersView(pushScreenAction: { route in
                coordinator.push(route: route)
            })
            .navigationDestination(for: DevelopersRouter.self) { route in
                coordinator.getView(route: route)
            }
            .navigationDestination(for: DetailsRouter.self) { route in
                route.getView()
            }
        }
    }
}
