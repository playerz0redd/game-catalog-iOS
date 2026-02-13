//
//  String+Extensions.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.02.26.
//

import Foundation


extension String {
    
    func getFirstWords(amount: Int) -> String {
        self.split(separator: " ").prefix(amount).joined(separator: " ")
    }
    
}
