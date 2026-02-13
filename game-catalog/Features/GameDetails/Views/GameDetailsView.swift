//
//  GameDetailsView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 8.02.26.
//

import SwiftUI
import Kingfisher
import AVKit

struct GameDetailsView: View {
    
    @ObservedObject private var viewModel: GameDetailsViewModel
    
    init(viewModel: GameDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
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
                    
                    infoBlock
                    
                    actionBlock
                    
                    descriptionBlock
                    
                    screenshotBlock
                    
                    moviesSection
                    
                    storeListView
                    
                    
                }
            }
            .navigationBarBackButtonHidden(viewModel.isHidingToolbar)
            .navigationBarHidden(viewModel.isHidingToolbar)
            .animation(.linear(duration: 0.5))

            .padding(.horizontal, 10)
            
            if let movie = viewModel.selectedMovie, let highRes = movie.videos.high, let url = URL(string: highRes) {
                MoviePlayerView(movieUrl: url, dismiss: viewModel.onMovieExit)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                    .zIndex(1)
            }
        }
        .animation(.smooth, value: viewModel.selectedMovie)
        .animation(.bouncy, value: viewModel.player)
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

private extension GameDetailsView {
    
    var storeListView: some View {
        VStack(alignment: .leading) {
            sectionCaption(caption: "Buy Here")
            
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
            
            Text(store.name)
                .font(.system(size: 13, weight: .semibold))
        }
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
            
            
            redTextButton(text: "All details about game", action: {})
    
        }
    }
    
    func redTextButton(text: LocalizedStringResource, action: @escaping () -> ()) -> some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.catalogOrange)
        }
    }
    
    func sectionCaption(caption: LocalizedStringResource) -> some View {
        Text(caption)
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
    }
    
    var screenshotBlock: some View {
        VStack(alignment: .leading) {
            Text("Screenshots")
                .font(.system(size: 26, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.detailsModel?.screenshots ?? [], id: \.id) { screenshot in
                        kfImage(url: screenshot.url)
                    }
                }
            }
        }
    }
}

private extension GameDetailsView {
    
    @ViewBuilder
    var moviesSection: some View {
        if let movies = viewModel.detailsModel?.videos, !movies.isEmpty {
            VStack(alignment: .leading) {
                sectionCaption(caption: "Trailers")
                
                moviesListView(movies: movies)
            }
        }
    }
    
    func moviesListView(movies: [GameVideoModel]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(movies, id: \.id) { movie in
                    movieView(movie: movie)
                        .onTapGesture {
                            viewModel.onMovieShow(movie: movie)
                        }
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
            ForEach(GameDetailsViewModel.ActionTypes.allCases, id: \.self) { type in
                actionButton(type: type)
            }
        }
        .foregroundStyle(.gray)
    }
    
    func actionButton(
        type: GameDetailsViewModel.ActionTypes
    ) -> some View {
        
        Button(action: type.action) {
            VStack {
                Image(systemName: type.image)
                    .font(.system(size: 23, weight: .medium))
                    .frame(minHeight: 32)
                
                Text(type.caption)
                    .font(.system(size: 13, weight: .medium))
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
