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
    @Published var viewState: ViewState<AuthServiceError>
    @Published var errors: [AuthServiceError] = []
    @Published var isShowingAlert = false
    
    private let authService: IAuthService
    private let authValidator: IAuthValidator = AuthValidationService()
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: IAuthService) {
        self.authService = authService
        self.viewState = .success
        
        self.authService.isAuthorizedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.self.isSigned, on: self)
            .store(in: &cancellables)
        
        self._viewState.projectedValue.sink { newValue in
            if case .error = newValue {
                self.isShowingAlert = true
            }
        }
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
    
    var errorMessage: LocalizedStringResource {
        if case .error(let error) = viewState {
            return error.errorDescription
        }
        return "Unknown error"
    }
    
    func hasError(for field: AuthField) -> AuthServiceError? {
        switch field {
        case .name:
            return errors.first(where: { error in
                if case .nameValidationError = error {
                    return true
                }
                return false
            })
        case .email:
            return errors.first(where: { error in
                if case .emailValidationError = error {
                    return true
                }
                return false
            })
        case .password:
            return errors.first(where: { error in
                if case .passwordValidationError(_, let fieldType) = error, fieldType == .password {
                    return true
                }
                return false
            })
        case .confirmPassword:
            return errors.first(where: { error in
                if case .passwordValidationError(_, let fieldType) = error, fieldType == .confirmPassword {
                    return true
                }
                return false
            })
        }
    }
    
    func register() {
        let dependency = RegisterDependency(
            name: authModel.name,
            email: authModel.email,
            password: authModel.password,
            confirmPassword: authModel.confirmPassword
        )
        self.errors = authValidator.validateRegister(dependency: dependency)
        guard self.errors.isEmpty else { return }
        
        Task {
            do {
                try await authService.createUser(email: authModel.email, passsword: authModel.password, name: authModel.name)
                await MainActor.run { isSigned = true }
            } catch let error as AuthServiceError {
                self.viewState = .error(error)
            }
        }
    }
    
    func signIn() {
        let dependency = AuthDependency(email: authModel.email, password: authModel.password)
        self.errors = authValidator.validateAuth(dependency: dependency)
        
        guard self.errors.isEmpty else { return }
        
        Task {
            do {
                try await authService.signIn(email: authModel.email, passsword: authModel.password)
                await MainActor.run { isSigned = true }
            } catch let error as AuthServiceError {
                self.viewState = .error(error)
            }
        }
    }
}

extension AuthViewModel {
    enum AuthField {
        case name
        case email
        case password
        case confirmPassword
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
