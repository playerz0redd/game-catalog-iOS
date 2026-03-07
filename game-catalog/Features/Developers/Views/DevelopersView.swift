//
//  DevelopersView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 26.02.26.
//

import SwiftUI
import Kingfisher

struct DevelopersView: View {
    @StateObject private var viewModel: DevelopersViewModel
    
    init(pushScreenAction: @escaping (_: DevelopersRouter) -> Void) {
        self._viewModel = StateObject(wrappedValue: DevelopersViewModel(service: GamesCatalogService(networkManager: NetworkManager(), persistanceManager: PersistanceManager.shared), pushScreenAction: pushScreenAction))
    }
    
    var body: some View {
        developersList
            .navigationTitle("Developers")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 8)
    }
}

private extension DevelopersView {
    
    var developersList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.developers, id: \.self) { developer in
                    developerView(imageUrl: developer.image, name: developer.name)
                        .onAppear {
                            viewModel.paginateDevelopers(currentId: developer.id)
                        }
                        .onTapGesture {
                            viewModel.pushScreenAction(.developerGames(games: developer.games))
                        }
                }
            }
        }
    }
    
    func developerView(imageUrl: String, name: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            KFImage(URL(string: imageUrl))
                .placeholder { ProgressView() }
                .onFailure { error in print("Ошибка: \(error)") }
                .cacheMemoryOnly(false)
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(16/9, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(name)
                .font(.system(size: 22, weight: .semibold))
        }
    }
}
