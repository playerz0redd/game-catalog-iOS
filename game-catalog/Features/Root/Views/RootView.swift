//
//  RootView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 28.02.26.
//

import Foundation
import SwiftUI
import Lottie

struct RootView: View {
    @ObservedObject private var viewModel: RootViewModel
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            startScreen
                .opacity(viewModel.isShowingSplash ? 0 : 1)
            
            splashView
            
        }
        .animation(.bouncy, value: viewModel.isSigned)
        .toolbarVisibility(viewModel.isShowingSplash ? .hidden : .visible, for: .tabBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.isShowingSplash = false
            }
        }
        .animation(.bouncy, value: viewModel.isShowingSplash)
        
    }
}

private extension RootView {
    
    @ViewBuilder
    var startScreen: some View {
        Group {
            if viewModel.isSigned {
                tabView
            } else {
                AuthView(viewModel: .init(authService: AuthService(authManager: AuthManager())))
            }
        }
        .transition(.slide.combined(with: .scale))
    }
    
}

private extension RootView {
    
    @ViewBuilder
    var splashView: some View {
        if viewModel.isShowingSplash {
            LottieView(animation: .named("start-new"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .frame(width: Constants.UIConstants.screenWidth, height: Constants.UIConstants.screenHeight)
                .transition(.opacity.combined(with: .scale).combined(with: .move(edge: .top)))
        }
    }
}

private extension RootView {
    var tabView: some View {
        TabView {
            Tab("Library", systemImage: "house.fill") {
                CatalogFlowView()
            }
            
            Tab("Developers", systemImage: "person.2.fill") {
                DevelopersFlowView()
            }
            
            Tab("Favorites", systemImage: "heart.fill") {
                FavoritesFlowView()
            }
            
            Tab("Profile", systemImage: "person") {
                ProfileFlowView()
            }
        }
    }
}
