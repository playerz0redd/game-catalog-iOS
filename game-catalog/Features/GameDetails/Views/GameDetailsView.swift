//
//  GameDetailsView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import SwiftUI
import Kingfisher
import AVKit
import Shimmer

struct GameDetailsView: View {
    
    @StateObject private var viewModel: GameDetailsViewModel
    
    init(service: IGamesCatalogService, gameId: Int, onScreenPush: @escaping (DetailsRouter) -> Void) {
        self._viewModel = StateObject(wrappedValue: .init(gameId: gameId, gamesService: service, onScreenPush: onScreenPush))
    }
    
    var body: some View {
        
        ZStack {
            switch viewModel.viewState {
            case .loading:
                DetailsSceletonView()
                    .transition(.opacity.combined(with: .scale))
            case .error(let error):
                Text(error.errorDescription)
                    .transition(.opacity.combined(with: .scale))
            case .success:
                detailsView
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.bouncy, value: viewModel.viewState)
        
    }
}

private extension GameDetailsView {
    var detailsView: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    
                    headerView
                    
                    infoBlock
                    
                    actionBlock
                    
                    descriptionBlock
                    
                    screenshotBlock
                    
                    moviesSection
                    
                    storeListView
                    
                    platformListView
                    
                    developersList
                    
                }
            }
            .navigationBarBackButtonHidden(viewModel.isHidingToolbar)
            .navigationBarHidden(viewModel.isHidingToolbar)
            .animation(.linear(duration: 0.5))
            .padding(.horizontal, 10)
            
            viewerView
        }
        .animation(.linear, value: viewModel.isShowingViewer)
        .animation(.smooth, value: viewModel.selectedMovie)
        .animation(.bouncy, value: viewModel.player)
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(viewModel.isShowingViewer ? .hidden : .visible, for: .tabBar)
        .toolbarVisibility(viewModel.isShowingVideo ? .hidden : .visible, for: .tabBar)
    }
}

private extension GameDetailsView {
    @ViewBuilder
    var headerView: some View {
        ZStack {
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            player.play()
                        }
                    }
            }
            
            gameImage
                .opacity(viewModel.player == nil ? 1 : 0)
        }
        
        Text(viewModel.detailsModel?.details.name ?? "no name")
            .font(.system(size: 20, weight: .bold))
    }
}

private extension GameDetailsView {
    func buttonMore(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 13) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 41))
                    .padding(15)
                    .background(
                        Circle()
                            .fill(Color(.systemGray6))
                    )
                
                Text("Show more")
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .foregroundStyle(.white)
    }
}

private extension GameDetailsView {
    
    var developersList: some View {
        VStack(alignment: .leading) {
            sectionCaption(caption: "Developed by", action: {viewModel.onScreenPush( DetailsRouter.allDevelopers(developers: viewModel.detailsModel?.developers ?? []))})
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.detailsModel?.developers.prefix(3) ?? [], id: \.self) { developer in
                        if let image = developer.image {
                            developerView(name: developer.name, image: image)
                                .onTapGesture {
                                    viewModel.isShowingViewer = true
                                    viewModel.selectedContent = .developers
                                    viewModel.isHidingToolbar = true
                                }
                        }
                    }
                    if let count = viewModel.detailsModel?.developers.count, count > 3 {
                        buttonMore(action: {viewModel.onScreenPush( DetailsRouter.allDevelopers(developers: viewModel.detailsModel?.developers ?? []))})
                    }
                }
            }
        }
    }
    
    func developerView(name: String, image: String) -> some View {
        VStack(alignment: .leading) {
            kfImage(url: image)
                .frame(width: 280, height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(name)
                .font(.system(size: 13, weight: .semibold))
        }
    }
    
}

private extension GameDetailsView {
    
    var storeListView: some View {
        VStack(alignment: .leading) {
            sectionCaption(caption: "Buy Here", action: nil)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 12) {
                    ForEach(viewModel.detailsModel?.storesWithGame ?? [], id: \.self) { store in
                        storeView(store: viewModel.storeDictionary[store]!)
                            .onTapGesture {
                                viewModel.safariLink = store.urlToStore
                                viewModel.isShowingSafari = true
                            }
                    }
                }
                
            }
        }
        .sheet(isPresented: $viewModel.isShowingSafari) {
            if let url = URL(string: viewModel.safariLink ?? "") {
                SafariView(url: url)
            }
        }
        
    }
    
    func storeView(store: StoreModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(viewModel.getStoreImage(storeId: store.id))
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(store.name)
                .font(.system(size: 13, weight: .semibold))
        }
    }
    
}

private extension GameDetailsView {
    var platformListView: some View {
        VStack(alignment: .leading) {
            sectionCaption(caption: "Available On", action: nil)
            
            if let platforms = viewModel.detailsModel?.details.platforms {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(platforms, id: \.platform.id) { platform in
                            platfromView(name: platform.platform.name)
                        }
                    }
                }
            }
        }
    }
    
    func platfromView(name: String) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(LinearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay {
                Text(name)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(.catalogOrange)
            }
            .frame(width: 200, height: 200)
    }
}

private extension GameDetailsView {
    
    var descriptionBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(viewModel.detailsModel?.details.description.getFirstWords(amount: 25) ?? "Description")
                .foregroundStyle(.primary)
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.6),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(maxWidth: .infinity)
            
            
            redTextButton(text: "All details about game", action: {viewModel.onScreenPush( DetailsRouter.movieDescription(description: viewModel.detailsModel?.details.description ?? "", ageRating: viewModel.detailsModel?.details.ageRating?.name ?? ""))})
    
        }
    }
    
    func redTextButton(text: LocalizedStringResource, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.catalogOrange)
        }
    }
    
    func sectionCaption(caption: LocalizedStringResource, action: (() -> Void)?) -> some View {
        HStack {
            Text(caption)
            
            Spacer()
            if let action = action {
                redTextButton(text: "All", action: action)
            }
        }
            .font(.system(size: 26, weight: .bold))
    }
    
    func kfImage(url: String) -> some View {
        KFImage(URL(string: url))
            .placeholder({ ProgressView() })
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(16/9, contentMode: .fill)
            .frame(maxWidth: 340, maxHeight: 220)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var screenshotBlock: some View {
        VStack(alignment: .leading) {
            sectionCaption(caption: "Screenshots", action: {
                viewModel.onScreenPush(DetailsRouter.allScreenshots(screenshots: viewModel.detailsModel?.screenshots ?? [])
                )
            })
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.detailsModel?.screenshots ?? [], id: \.id) { screenshot in
                        kfImage(url: screenshot.url)
                            .onTapGesture {
                                viewModel.isShowingViewer = true
                                viewModel.selectedContent = .screenshots
                                viewModel.isHidingToolbar = true
                            }
                    }
                    
                    buttonMore {
                        viewModel.onScreenPush(DetailsRouter.allScreenshots(screenshots: viewModel.detailsModel?.screenshots ?? [])
                        )
                    }
                }
            }
        }
    }
}

private extension GameDetailsView {
    
    @ViewBuilder
    var viewerView: some View {
        
        // NEEDS REFACTOR
        
        if viewModel.isShowingViewer {
            switch viewModel.selectedContent {
            case .trailers:
                if let movie = viewModel.selectedMovie,
                   let highRes = movie.videos.high,
                   let url = URL(string: highRes) {
                    ContentViewer(
                        onDismiss: {viewModel.isShowingViewer = false; viewModel.isHidingToolbar = false},
                        content: {
                            MoviePlayerView(movieUrl: url)
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                }
                
            case .screenshots:
                ContentViewer(onDismiss: {viewModel.isShowingViewer = false; viewModel.isHidingToolbar = false}) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.detailsModel?.screenshots ?? [], id: \.id) { screenshot in
                                KFImage(URL(string: screenshot.url))
                                    .resizable()
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .containerRelativeFrame(.horizontal)
                                    .clipped()
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
            case .developers:
                ContentViewer(onDismiss: {viewModel.isShowingViewer = false; viewModel.isHidingToolbar = false}) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.detailsModel?.developers ?? [], id: \.id) { developer in
                                KFImage(URL(string: developer.image ?? ""))
                                    .resizable()
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .containerRelativeFrame(.horizontal)
                                    .clipped()
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .bottom).combined(with: .opacity)
                ))
            case .none:
                EmptyView()
            }
        }
    }
}

private extension GameDetailsView {
    
    @ViewBuilder
    var moviesSection: some View {
        if let movies = viewModel.detailsModel?.videos, !movies.isEmpty {
            VStack(alignment: .leading) {
                sectionCaption(caption: "Trailers", action: { viewModel.onScreenPush( DetailsRouter.allVideos(trailers: viewModel.detailsModel?.videos ?? [])) })
                
                moviesListView(movies: movies)
            }
        }
    }
    
    func moviesListView(movies: [GameVideoModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(movies, id: \.id) { movie in
                    movieView(movie: movie)
                        .onTapGesture {
                            viewModel.isShowingViewer = true
                            viewModel.selectedContent = .trailers
                            viewModel.selectedMovie = movie
                            viewModel.isHidingToolbar = true
                        }
                }
                
                buttonMore {
                    viewModel.onScreenPush(DetailsRouter.allVideos(trailers: viewModel.detailsModel?.videos ?? []))
                }
            }
        }
    }
    
    func movieView(movie: GameVideoModel) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            kfImage(url: movie.preview)
            
            Text(movie.name)
                .font(.system(size: 14, weight: .semibold))
                .lineLimit(1)
        }
        .frame(maxWidth: 340)
    }
}

private extension GameDetailsView {
    
    var infoBlock: some View {
        VStack {
            HStack {
                Text(String(viewModel.detailsModel?.details.rating ?? 0))
                    .bold()
                Text(String(viewModel.detailsModel?.details.ratingsCount ?? 0))
                
                Text(viewModel.detailsModel?.details.originalName ?? "no name")
            }
            
            HStack {
                Text(viewModel.detailsModel?.details.releaseDate ?? .init(), format: Date.FormatStyle(date: .numeric, time: .omitted))
                
                Text(viewModel.genres)
            }
        }
    }
    
    var actionBlock: some View {
        HStack(spacing: 35) {
            
            actionButton(
                image: viewModel.isLiked ? "heart.fill" : "heart",
                caption: "Will play",
                color: viewModel.isLiked ? .red : .gray,
                action: viewModel.favoritesAction
            )
            
            if let url = URL(string: viewModel.detailsModel?.storesWithGame?.first?.urlToStore ?? "") {
                ShareLink(item: url, subject: Text("Rate a game"), message: Text(viewModel.detailsModel?.details.name ?? "Game name")) {
                    shareButton
                }
            }
        }
    }
    
    var shareButton: some View {
        VStack {
            Image(systemName: "arrowshape.turn.up.right")
                .font(.system(size: 23, weight: .medium))
                .frame(minHeight: 32)
                .foregroundStyle(.gray)
            
            Text("Share")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.gray)
        }
    }
    
    func actionButton(
        image: String,
        caption: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        
        Button(action: action) {
            VStack {
                Image(systemName: image)
                    .font(.system(size: 23, weight: .medium))
                    .frame(minHeight: 32)
                    .foregroundStyle(color)
                
                Text(caption)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.gray)
            }
            
        }
    }
    
    
}

private extension GameDetailsView {
    
    @ViewBuilder var gameImage: some View {
        KFImage(URL(string: viewModel.detailsModel?.details.imageUrl ?? ""))
            .placeholder { ProgressView() }
            .onFailure { error in print("Ошибка: \(error)") }
            .cacheMemoryOnly(false)
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .overlay {
                LinearGradient(colors: [.black.opacity(0), .black.opacity(0.3), .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
            }
    }
    
}
