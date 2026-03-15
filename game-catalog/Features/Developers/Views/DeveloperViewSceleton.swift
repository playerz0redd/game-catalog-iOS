//
//  DeveloperViewSceleton.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.03.26.
//

import Foundation
import SwiftUI
import Shimmer


struct DeveloperViewSceleton: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(0..<3) { _ in
                    VStack(alignment: .leading, spacing: 15) {
                        imageRect
                        imageCaptionRect
                    }
                }
            }
            .foregroundStyle(.appGray)
            .shimmering()
        }
    }
    
    var imageRect: some View {
        RoundedRectangle(cornerRadius: 16)
            .frame(maxWidth: .infinity)
            .frame(height: 240)
    }
    
    var imageCaptionRect: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: 250, height: 40)
    }
}
