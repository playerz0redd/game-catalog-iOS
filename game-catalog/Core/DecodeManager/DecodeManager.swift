//
//  DecodeManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.02.26.
//

import Foundation
import UIKit

protocol IDecoder {
    static func decode<T: Decodable>(data: Data, as type: T.Type) throws(DecoderError) -> T
}

struct DecodeManager: IDecoder {
    
    static func decode<T: Decodable>(data: Data, as type: T.Type) throws(DecoderError) -> T {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            return try decoder.decode(type, from: data)
        } catch let error {
            throw .decoderError(reason: error.localizedDescription)
        }
    }
    
    static func decodeToImage(data: Data) throws(DecoderError) -> UIImage? {
        guard let image = UIImage(data: data) else { throw .decodeToImageError }
        return image
    }
    
    
}
