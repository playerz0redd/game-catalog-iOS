//
//  AuthManager.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 1.03.26.
//

import Foundation
import FirebaseAuth
import Combine

protocol IAuthManager {
    func createUser(email: String, password: String, name: String) async throws(AuthError)
    func signIn(email: String, password: String) async throws(AuthError)
    func signOut() throws(AuthError)
    var userPublisher: AnyPublisher<User?, Never> { get }
    var isUserSigned: Bool { get }
    var getUser: User? { get }
}

final class AuthManager: IAuthManager {
    
    private let auth = Auth.auth()
    private let userSubject: CurrentValueSubject<User?, Never>
    private var handler: AuthStateDidChangeListenerHandle?
    
    var userPublisher: AnyPublisher<User?, Never> {
        userSubject.eraseToAnyPublisher()
    }
    
    init() {
        
        self.userSubject = CurrentValueSubject<User?, Never>(Auth.auth().currentUser)
        
        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userSubject.send(user)
        }
    }
    
    var getUser: User? {
        auth.currentUser
    }
    
    
    func createUser(email: String, password: String, name: String) async throws(AuthError) {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            
            try await changeRequest.commitChanges()
            
            self.userSubject.send(auth.currentUser)
        } catch let error {
            throw .invalidRegistration(error)
        }
    }
    
    func signIn(email: String, password: String) async throws(AuthError) {
        do {
            try await auth.signIn(withEmail: email, password: password)
        } catch let error {
            throw .invalidLogin(error)
        }
    }
        
    
    func signOut() throws(AuthError) {
        do {
            try auth.signOut()
        } catch let error {
            throw .invalidSignOut(error)
        }
    }
    
    var isUserSigned: Bool {
        auth.currentUser != nil
    }
    
    deinit {
        if let handler = handler {
            auth.removeStateDidChangeListener(handler)
        }
    }
    
    
}
