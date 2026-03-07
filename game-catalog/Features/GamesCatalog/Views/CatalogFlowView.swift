//
//  ContentView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI
import Lottie

struct CatalogFlowView: View {
    
    @StateObject private var coordinator = CatalogCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.getView(route: .catalog)
                .navigationDestination(for: CatalogRouter.self) { route in
                    coordinator.getView(route: route)
                }
                .navigationDestination(for: DetailsRouter.self) { route in
                    route.getView()
                }
        }
        .transition(.opacity.combined(with: .scale).combined(with: .slide))
    }
}
