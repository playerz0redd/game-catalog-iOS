//
//  DetailsSceletonView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.03.26.
//

import SwiftUI
import Shimmer

struct DetailsSceletonView: View {
    var body: some View {
        VStack(spacing: 30) {
            
            RoundedRectangle(cornerRadius: 14)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.UIConstants.screenHeight / 3)
            
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 250, height: 30)
                
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 300, height: 30)
                
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 250, height: 30)
            }
            
            HStack(spacing: 40) {
                buttonSceleton
                
                buttonSceleton
            }
            
            VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 250, height: 30)
                
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 300, height: 30)
                
                RoundedRectangle(cornerRadius: 14)
                    .frame(width: 250, height: 30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .foregroundStyle(.appGray)
        .shimmering(gradient)
    }
}

private extension DetailsSceletonView {
    
    var buttonSceleton: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 70, height: 30)
        }
    }
}

