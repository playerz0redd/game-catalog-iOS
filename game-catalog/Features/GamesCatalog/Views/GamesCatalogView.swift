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

                
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.games, id: \.id) { game in
                        GameCell(game: game)
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
        .overlay(alignment: .top) {
            if viewModel.isHeaderVisible {
                HStack {
                    genrePickerButton
                    
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("Поиск")
                        .foregroundStyle(.black)
                        .font(.system(size: 14, weight: .semibold))
                    )
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.leading, 10)
                    .padding(.vertical, 6.5)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.95))
                    }
                    .onSubmit {
                        viewModel.findGameBySearch()
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.horizontal, 2)
            }
        }
        .animation(.bouncy, value: viewModel.isHeaderVisible)
        .onScrollGeometryChange(for: CGFloat.self, of: { geo in
            geo.contentOffset.y
        }, action: { oldValue, newValue in
            if newValue > oldValue && newValue > 50 {
                viewModel.isHeaderVisible = false
            }
            else if newValue < oldValue {
                viewModel.isHeaderVisible = true
            }
        })
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
    
    var genrePickerButton: some View {
        Button {
            viewModel.onGenreButtonClick()
        } label: {
            HStack {
                CapsuleWithContent {
                    HStack {
                        Text(viewModel.selectedGenre == nil ? "Жанры" : viewModel.selectedGenre!)
                        
                        Image(systemName: viewModel.selectedGenre == nil ? "chevron.down" : "xmark")
                    }
                    .foregroundStyle(.black)
                }
                
            }
        }
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
