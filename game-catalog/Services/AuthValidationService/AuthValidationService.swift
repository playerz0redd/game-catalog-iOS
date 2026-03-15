//
//  AuthValidationService.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 14.03.26.
//

import Foundation

struct AuthDependency {
    let email: String
    let password: String
}

struct RegisterDependency {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
}

protocol IAuthValidator {
    func validateAuth(dependency: AuthDependency) -> [AuthServiceError]
    func validateRegister(dependency: RegisterDependency) -> [AuthServiceError]
}

struct AuthValidationService: IAuthValidator {
    
    func validateAuth(dependency: AuthDependency) -> [AuthServiceError] {
        validateEmail(dependency.email) + validatePassword(dependency.password, fieldType: .password)
    }
    
    func validateRegister(dependency: RegisterDependency) -> [AuthServiceError] {
        validateName(dependency.name) + validateEmail(dependency.email) + validatePassword(dependency.password, fieldType: .password) + validatePassword(dependency.confirmPassword, fieldType: .confirmPassword) + comparePasswords(dependency.confirmPassword, dependency.password)
    }
    
    private func validateEmail(_ email: String) -> [AuthServiceError] {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) ? [] : [.emailValidationError]
    }
    
    private func validateName(_ name: String) -> [AuthServiceError] {
        var errors: [AuthServiceError] = []
        if name.isEmpty {
            errors.append(.nameValidationError(.empty))
        }
        if name.count < 3 {
            errors.append(.nameValidationError(.tooShort))
        }
        if name.count > 15 {
            errors.append(.nameValidationError(.tooLong))
        }
        return errors
    }
    
    private func validatePassword(_ password: String, fieldType: AuthViewModel.AuthField) -> [AuthServiceError] {
        var errors: [AuthServiceError] = []
        if password.isEmpty {
            errors.append(.passwordValidationError(.empty, fieldType))
        }
        if password.count < 6 {
            errors.append(.passwordValidationError(.tooShort, fieldType))
        }
        if password.count > 25 {
            errors.append(.passwordValidationError(.tooLong, fieldType))
        }
        return errors
    }
    
    private func comparePasswords(_ password1: String, _ password2: String) -> [AuthServiceError] {
        password1 == password2 ? [] : [
                .passwordValidationError(.passwordsAreNotEqual, .password),
                .passwordValidationError(.passwordsAreNotEqual, .confirmPassword)
        ]
    }
    
    
}
