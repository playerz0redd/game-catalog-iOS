//
//  ContentView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.getView(route: .catalog)
                .navigationDestination(for: AppRouter.self) { route in
                    coordinator.getView(route: route)
                }
        }
        .environmentObject(coordinator)
    }
}
