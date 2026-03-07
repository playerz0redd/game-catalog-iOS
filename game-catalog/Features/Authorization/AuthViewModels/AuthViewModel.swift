//
//  AuthViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 1.03.26.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    
    @Published var authModel: AuthModel = .init()
    @Published var isSigned: Bool = false
    @Published var authType: AuthType = .registration
    
    private let authService: IAuthService
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: IAuthService) {
        self.authService = authService
        
        self.authService.isAuthorizedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.self.isSigned, on: self)
            .store(in: &cancellables)
    }
    
    func onSubmit() {
        switch authType {
        case .registration:   register()
        case .login:          signIn()
        }
    }
    
    func typeSelectionAction() {
        switch authType {
        case .registration:    authType = .login
        case .login:           authType = .registration
        }
    }
    
    func register() {
        Task {
            do {
                try await authService.createUser(email: authModel.email, passsword: authModel.password, name: authModel.name)
                await MainActor.run { isSigned = true }
            } catch let error {
                
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                try await authService.signIn(email: authModel.email, passsword: authModel.password)
                await MainActor.run { isSigned = true }
            } catch let error {
                
            }
        }
    }
}

extension AuthViewModel {
    enum AuthType: Int, CaseIterable {
        
        case registration
        case login
        
        var actionButtonTitle: LocalizedStringResource {
            switch self {
            case .registration:      "Register"
            case .login:             "Login"
            }
        }
        
        var title: LocalizedStringResource {
            switch self {
            case .registration:      "Registration"
            case .login:             "Login"
            }
        }
    }
}
