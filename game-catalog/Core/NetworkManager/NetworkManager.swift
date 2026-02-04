//
//  NetworkManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation


protocol INetworkManager {
    func fetch(url: String) async throws -> Data
}

struct NetworkManager: INetworkManager {
    
    func fetch(url: String) async throws -> Data {
        guard let url = URL(string: url) else { return .init() }
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode != 200 else { return .init() }
        
        return data
    }
    
}
