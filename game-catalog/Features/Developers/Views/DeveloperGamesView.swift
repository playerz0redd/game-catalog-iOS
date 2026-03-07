//
//  DeveloperGamesView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 27.02.26.
//

import SwiftUI

struct DeveloperGamesView: View {
    
    private let games: [DeveloperModel.GameModel]
    private let pushScreenAction: (_: DevelopersRouter) -> Void
    
    init(games: [DeveloperModel.GameModel], pushScreenAction: @escaping (_: DevelopersRouter) -> Void) {
        self.games = games
        self.pushScreenAction = pushScreenAction
    }
    
    var body: some View {
        gamesList
            .padding(.horizontal, 10)
            .navigationTitle("Developer Games")
            .navigationBarTitleDisplayMode(.inline)
    }
}

private extension DeveloperGamesView {
    var gamesList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(games, id: \.self) { game in
                    gameView(game: game)
                        .onTapGesture {
                            pushScreenAction(.gameDetails(gameId: game.id))
                        }
                }
            }
        }
    }
}

private extension DeveloperGamesView {
    func gameView(game: DeveloperModel.GameModel) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, minHeight: 280)
            .foregroundStyle(LinearGradient(
                colors:
                    [
                        Color(red: 238/255, green: 110/255, blue: 245/255),
                        Color(red: 87/255, green: 185/255, blue: 255/255)
                    ],
                startPoint: .leading,
                endPoint: .trailing)
            )
            .overlay(alignment: .center) {
                Text(game.name)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.catalogOrange)
            }
    }
}

