//
//  AuthService.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 1.03.26.
//

import Foundation
import Combine

protocol IAuthService {
    
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> { get }
    func createUser(email: String, passsword: String, name: String) async throws(AuthServiceError)
    func signIn(email: String, passsword: String) async throws(AuthServiceError)
    func signOut() async throws(AuthServiceError)
    
}

final class AuthService: IAuthService {
    
    private let authManager: IAuthManager
    
    init(authManager: IAuthManager) {
        self.authManager = authManager
    }
    
    var isAuthorizedPublisher: AnyPublisher<Bool, Never> {
        authManager.userPublisher.map({ $0 != nil}).eraseToAnyPublisher()
    }
    
    func createUser(email: String, passsword: String, name: String) async throws(AuthServiceError) {
        do {
            try await authManager.createUser(email: email, password: passsword, name: name)
        } catch let error {
            throw .registrationError(error)
        }
    }
    
    func signIn(email: String, passsword: String) async throws(AuthServiceError) {
        do {
            try await authManager.signIn(email: email, password: passsword)
        } catch let error {
            throw .signInError(error)
        }
    }
    
    func signOut() async throws(AuthServiceError) {
        do {
            try authManager.signOut()
        } catch let error {
            throw .signOutError(error)
        }
    }
}
