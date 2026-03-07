//
//  AllTrailersView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 25.02.26.
//

import SwiftUI
import Kingfisher

struct AllItemsView<T: IDataList>: View {
    
    //MARK: - Rx Properties
    @State private var isShowingViewer: Bool = false
    @State private var selectedID: T.ID?
    @State private var selectedItem: T?
    
    //MARK: - Properties
    private let items: [T]
    private let title: LocalizedStringResource
    
    //MARK: - Init
    init(items: [T], title: LocalizedStringResource) {
        self.items = items
        self.title = title
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    itemList
                }
            }
            
            viewerView
            
        }
        .animation(.snappy, value: isShowingViewer)
        .padding(.horizontal, 10)
        .navigationTitle(title)
        .navigationBarHidden(isShowingViewer)
        .animation(.bouncy)
        .toolbarVisibility(isShowingViewer ? .hidden : .visible, for: .tabBar)
        
    }
}

private extension AllItemsView {
    
    @ViewBuilder
    var viewerView: some View {
        if isShowingViewer {
            ContentViewer(onDismiss: {isShowingViewer = false}) {
                if let item = selectedItem, item.isVideo {
                    MoviePlayerView(movieUrl: URL(string: item.videoUrl)!)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            itemList
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $selectedID)
                    .scrollTargetBehavior(.paging)
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
        }
    }
}

private extension AllItemsView {
    
    @ViewBuilder
    var itemList: some View {
        ForEach(items, id: \.id) { item in
            itemView(imageUrl: item.imageUrl, title: item.title)
                .id(item.id)
                .onTapGesture {
                    selectedID = item.id
                    selectedItem = item
                    isShowingViewer = true
                }
        }
    }
    
    func itemView(imageUrl: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            KFImage(URL(string: imageUrl))
                .placeholder({ ProgressView() })
                .resizable()
                .aspectRatio(16/9, contentMode: .fit)
                .containerRelativeFrame(.horizontal)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
            }
        }
    }
}
