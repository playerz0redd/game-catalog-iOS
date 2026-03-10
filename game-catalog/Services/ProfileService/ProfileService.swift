//
//  ProfileService.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 2.03.26.
//

import Foundation
import UIKit
import FirebaseAuth

protocol IProfileService {
    func savePhoto(image: UIImage, name: String) throws(ProfileServiceError)
    func fetchPhoto(name: String) -> UIImage?
    func deletePhoto(name: String) throws(ProfileServiceError)
    
    func signOut() throws(ProfileServiceError)
    func getUser() -> UserProfileModel?
}

final class ProfileService: IProfileService {
    
    private let storageManager: IStorageManager
    private let authManager: IAuthManager
    
    init(storageManager: IStorageManager, authManager: IAuthManager) {
        self.storageManager = storageManager
        self.authManager = authManager
    }
    
    func getUser() -> UserProfileModel? {
        if let user = authManager.getUser, let userName = user.displayName, let email = user.email {
            return .init(name: userName, email: email)
        }
        return nil
        
    }
    
    func savePhoto(image: UIImage, name: String) throws(ProfileServiceError) {
        do {
            try storageManager.savePhoto(image: image, name: name)
        } catch let error {
            throw .storageError(error)
        }
    }
    
    func fetchPhoto(name: String) -> UIImage? {
        storageManager.fetchPhoto(name: name)
    }
    
    func deletePhoto(name: String) throws(ProfileServiceError) {
        do {
            try storageManager.deletePhoto(name: name)
        } catch let error {
            throw .storageError(error)
        }
    }
    
    func signOut() throws(ProfileServiceError) {
        do {
            try authManager.signOut()
        } catch let error {
            throw .authError(error)
        }
    }
}
