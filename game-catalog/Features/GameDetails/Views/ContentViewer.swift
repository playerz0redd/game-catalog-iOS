//
//  ContentViewer.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 20.02.26.
//

import SwiftUI

struct ContentViewer<Content: View>: View {
    
    @State private var dragOffset: CGSize = .zero
    @State private var opacity: Double = 1
    @State private var isDraggingDown: Bool = false
    
    private let onDismiss: () -> Void
    private let content: Content
    
    init(
        onDismiss: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            
            Color.black
            
            content
                .offset(dragOffset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { gesture in
                            let verticalDrag = gesture.translation.height
                            let horizontalDrag = gesture.translation.width
                            
                            if !isDraggingDown {
                                if abs(verticalDrag) > abs(horizontalDrag) && verticalDrag > 0 {
                                    isDraggingDown = true
                                }
                            }
                            
                            if isDraggingDown {
                                dragOffset = gesture.translation
                                opacity = 1 - gesture.translation.height / Constants.UIConstants.screenHeight
                            }
                        }
                        .onEnded { gesture in
                            if dragOffset.height > Constants.UIConstants.screenHeight / 3 {
                                onDismiss()
                            } else {
                                opacity = 1
                                dragOffset = .zero
                                isDraggingDown = false
                            }
                        }
                )
        }
        .opacity(opacity)
        .animation(.snappy, value: dragOffset)
        .animation(.snappy, value: opacity)
        .ignoresSafeArea()
    }
}
