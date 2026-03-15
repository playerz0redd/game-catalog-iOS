//
//  GamesCatalogSceleton.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 14.03.26.
//

import Foundation
import SwiftUI
import Shimmer


struct GamesCatalogSceleton: View {
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0..<10) { _ in
                    VStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 180)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 20)
                        
                    }
                    
                }
            }
        }
        .foregroundStyle(.appGray)
        .shimmering()
    }
}
