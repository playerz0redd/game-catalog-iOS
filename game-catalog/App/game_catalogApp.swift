//
//  game_catalogApp.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI
import Kingfisher
import Firebase

@main
struct game_catalogApp: App {
    
    @StateObject private var languageManager: LanguageManager = .init()
    
    init() {
        configureKingfisher()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init(authService: AuthService(authManager: AuthManager())))
                .environment(\.locale, languageManager.locale)
                .environmentObject(languageManager)
        }
    }
}

extension game_catalogApp {
    func configureKingfisher() {
        let modifier = AnyModifier { request in
            var r = request
            r.timeoutInterval = 15
            return r
        }
        
        KingfisherManager.shared.defaultOptions = [
            .requestModifier(modifier),
            .backgroundDecode,
            .transition(.fade(0.2)),
            .cacheSerializer(FormatIndicatedCacheSerializer.png)
        ]
    }
}
