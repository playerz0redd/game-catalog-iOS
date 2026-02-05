//
//  game_catalogApp.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI
import Kingfisher

@main
struct game_catalogApp: App {
    
    init() {
        configureKingfisher()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
            .backgroundDecode, // Тот самый фикс фризов
            .transition(.fade(0.2)),
            .cacheSerializer(FormatIndicatedCacheSerializer.png) // Быстрее для рендеринга
        ]
    }
}
