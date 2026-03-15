//
//  NetworkManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation


protocol INetworkManager {
    func fetch(url: URL?) async throws(NetworkError) -> Data
}

struct NetworkManager: INetworkManager {
    
    func fetch(url: URL?) async throws(NetworkError) -> Data {
        guard let url = url else { throw .urlError }
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                let r = response as? HTTPURLResponse
                throw NetworkError.serverError(code: r?.statusCode ?? 0)
            }
            
            return data
        } catch let error as NetworkError {
            throw error
        } catch let error {
            throw .requestError(error)
        }
    }
    
}
