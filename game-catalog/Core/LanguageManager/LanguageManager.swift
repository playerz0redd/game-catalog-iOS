//
//  LanguageManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 2.03.26.
//

import SwiftUI
import Combine


final class LanguageManager: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "ru"
    
    var locale: Locale {
        Locale(identifier: selectedLanguage)
    }
}
