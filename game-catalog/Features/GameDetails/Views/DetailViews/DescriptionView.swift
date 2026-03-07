//
//  DescriptionView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 25.02.26.
//

import SwiftUI

struct DescriptionView: View {
    
    let desctiption: String
    let ageRating: String
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 20) {
                Text(desctiption)
                    .font(.system(size: 15))
                
                Text(ageRating)
                    .padding(5)
                    .foregroundStyle(.gray)
                    .background {
                        Capsule()
                            .stroke(Color.gray, lineWidth: 1.5)
                    }
                    .padding(.leading, 4)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 10)
        .navigationTitle("Description")
        
        
    }
}
