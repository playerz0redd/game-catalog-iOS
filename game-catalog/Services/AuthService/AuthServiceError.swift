//
//  AuthServiceError.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 5.03.26.
//

import Foundation

enum AuthServiceError: Equatable, Sendable {
    
    nonisolated static func ==(lhs: AuthServiceError, rhs: AuthServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.registrationError, .registrationError), (.signInError, .signInError), (.signOutError, .signOutError), (.nameValidationError, .nameValidationError), (.emailValidationError, .emailValidationError), (.passwordValidationError, .passwordValidationError): true
        default: false
        }
    }
    
    case registrationError(AuthError)
    case signInError(AuthError)
    case signOutError(AuthError)
    case nameValidationError(ValidationNameError)
    case emailValidationError
    case passwordValidationError(ValidationPasswordError, AuthViewModel.AuthField)
    
    enum ValidationPasswordError: Error {
        
        case tooShort
        case tooLong
        case passwordsAreNotEqual
        case empty
        
        var description: LocalizedStringResource {
            switch self {
            case .tooShort:                     "Password is too short"
            case .tooLong:                      "Password is too long"
            case .passwordsAreNotEqual:         "Passwords are not equal"
            case .empty:                        "Password is empty"
            }
        }
    }
    
    enum ValidationNameError: Error {
        case tooShort
        case tooLong
        case empty
        
        var description: LocalizedStringResource {
            switch self {
            case .tooShort:          "Name is too short"
            case .tooLong:           "Name is too long"
            case .empty:             "Name is empty"
            }
        }
    }
    
}

extension AuthServiceError: IAppError {
    var errorDescription: LocalizedStringResource {
        switch self {
        case .registrationError(let authError):                        authError.errorDescription
        case .signInError(let authError):                              authError.errorDescription
        case .signOutError(let authError):                             authError.errorDescription
        case .nameValidationError(let nameError):                      nameError.description
        case .emailValidationError:                                    "Email is not correct"
        case .passwordValidationError(let passwordError, let field):   passwordError.description
        }
    }
    
    var needsRefresh: Bool {
        switch self {
        case .registrationError(let authError):      authError.needsRefresh
        case .signInError(let authError):            authError.needsRefresh
        case .signOutError(let authError):           authError.needsRefresh
        case .nameValidationError, .emailValidationError, .passwordValidationError: true
        }
    }
    
    
}
