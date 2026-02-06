//
//  CapsuleWithContent.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 6.02.26.
//

import SwiftUI

struct CapsuleWithContent<Content: View>: View {
    
    @ViewBuilder private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        content
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background {
                Capsule()
                    .stroke(lineWidth: 1.2)
            }
            .foregroundStyle(.gray)
            .opacity(0.55)
        
    }
}
