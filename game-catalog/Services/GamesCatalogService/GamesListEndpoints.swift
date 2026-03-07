//
//  GamesListEndpoints.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation

enum GameApiEndpoints {
    case listGames(page: Int, genre: String? = nil, search: String? = nil)
    case genres(page: Int)
    case gameDetails(gameId: Int)
    case gameScreenshots(gameId: Int)
    case gameStores(gameId: Int)
    case gameVideos(gameId: Int)
    case stores
    case creators(gameId: Int)
    case developers(page: Int)
    
    private var path: String {
        switch self {
        case .listGames:                       "games"
        case .genres:                          "genres"
        case .gameDetails(let gameId):         "games/\(gameId)"
        case .gameScreenshots(let gameId):     "games/\(gameId)/screenshots"
        case .gameStores(let gameId):          "games/\(gameId)/stores"
        case .gameVideos(let gameId):          "games/\(gameId)/movies"
        case .stores:                          "stores"
        case .creators(let gameId):            "games/\(gameId)/development-team"
        case .developers:                      "developers"
        }
    }
    
    private static let BASE_URL: String = "https://api.rawg.io/api/"
    private static let PAGE_SIZE = 40
    private var token: String {
        Bundle.main.object(forInfoDictionaryKey: "GAMES_API_TOKEN") as! String
    }
    
    var url: URL? {
        guard var components = URLComponents(string: Self.BASE_URL + path) else { return nil }
        
        var queryItems: [URLQueryItem] = [.init(name: "key", value: token)]
        
        switch self {
        case .listGames(let page, let genre, let search):
            queryItems.append(.init(name: "page", value: String(page)))
            queryItems.append(.init(name: "page_size", value: String(Self.PAGE_SIZE)))
            if let genre = genre {
                queryItems.append(.init(name: "genre", value: genre))
            }
            if let search = search {
                queryItems.append(.init(name: "search", value: search))
            }
        case .genres(let page):
            queryItems.append(.init(name: "page", value: String(page)))
        case .gameDetails:
            break
        case .gameScreenshots:
            queryItems.append(.init(name: "page_size", value: String(Self.PAGE_SIZE)))
        case .gameStores:
            queryItems.append(.init(name: "page_size", value: String(Self.PAGE_SIZE)))
        case .gameVideos:
            break
        case .stores:
            queryItems.append(.init(name: "page_size", value: String(Self.PAGE_SIZE)))
        case .creators:
            queryItems.append(.init(name: "page_size", value: String(Self.PAGE_SIZE)))
        case .developers(let page):
            queryItems.append(.init(name: "page_size", value: String(Self.PAGE_SIZE)))
            queryItems.append(.init(name: "page", value: String(page)))
        }
        
        components.queryItems = queryItems
        return components.url
    }
}
