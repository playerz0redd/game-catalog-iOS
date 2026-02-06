//
//  GamesCatalogView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import SwiftUI


struct GamesCatalogView: View {
    @ObservedObject private var viewModel: GamesCatalogViewModel
    
    init(viewModel: GamesCatalogViewModel) {
        self.viewModel = viewModel
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Button {
                    viewModel.isShowingGenres = true
                } label: {
                    CapsuleWithContent {
                        HStack {
                            Text("Категории")
                            
                            Image(systemName: "chevron.down")
                        }
                    }
                    .padding(.leading, 2)
                }

                
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.games, id: \.id) { game in
                        GameCell(imageLoader: viewModel.gamesCatalogService, game: game)
                            .onAppear {
                                if game.id == viewModel.games[viewModel.games.count - 10].id {
                                    viewModel.loadMoreGames()
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .animation(.bouncy, value: viewModel.games)
        .blur(radius: viewModel.isShowingGenres ? 30 : 0)
        .overlay {
            ZStack {
                if viewModel.isShowingGenres {
                    
                    Color.black
                        .opacity(viewModel.isShowingGenres ? 0.4 : 0)
                        .blur(radius: viewModel.isShowingGenres ? 30 : 0)
                    
                    genresView
                        .overlay(alignment: .bottom) {
                            exitButton
                        }
                        .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .animation(.easeInOut, value: viewModel.isShowingGenres)
    
    }
}

private extension GamesCatalogView {
    
    var genresView: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 17) {
                
                Spacer(minLength: 130)
                
                ForEach(viewModel.genres, id: \.id) { genre in
                    Button {
                        viewModel.onGenreSelect(genre: genre.name)
                    } label: {
                        Text(genre.name)
                            .font(.system(size: 18, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white.opacity(0.3))
                    }

                }
                
                Spacer(minLength: 110)
            }
            .padding(.leading, 30)
        }
    }
    
    var exitButton: some View {
        Button {
            viewModel.isShowingGenres = false
        } label: {
            Circle()
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                }
        }

    }
    
}
