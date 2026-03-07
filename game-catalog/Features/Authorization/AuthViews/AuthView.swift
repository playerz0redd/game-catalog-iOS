//
//  AuthView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 1.03.26.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @ObservedObject private var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 30) {
            headerView
            
            VStack(spacing: 20) {
                authTypesView
                
                inputFields
                
                actionButton
            
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.authBackgroundGray)
                    .stroke(.blue)
            }
            .padding(.horizontal, 30)
            
        }
        .animation(.bouncy, value: viewModel.authType)
    }
}

private extension AuthView {
    
    var actionButton: some View {
        Button(action: viewModel.onSubmit) {
            Text(viewModel.authType.actionButtonTitle)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .font(.system(size: 25, weight: .semibold))
                .background {
                    RoundedRectangle(cornerRadius: 18)
                        .foregroundStyle(LinearGradient(colors: [.init(red: 42/255, green: 103/255, blue: 232/255), .init(red: 47/255, green: 140/255, blue: 188/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
        }
        
    }
    
}

private extension AuthView {
    
    var inputFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if viewModel.authType == .registration {
                textField(isSecured: false, value: $viewModel.authModel.name, title: "Name", prompt: "Enter Your Name")
            }
            
            textField(isSecured: false, value: $viewModel.authModel.email, title: "Email", prompt: "example@mail.com")
                .keyboardType(.emailAddress)
            
            textField(isSecured: true, value: $viewModel.authModel.password, title: "Password", prompt: "Enter Your Password")
            
            if viewModel.authType == .registration {
                textField(isSecured: true, value: $viewModel.authModel.confirmPassword, title: "Confirm Password", prompt: "Confirm Your Password")
            }
        }
    }
    
    func textField(
        isSecured: Bool,
        value: Binding<String>,
        title: LocalizedStringResource,
        prompt: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
            
            if !isSecured {
                TextField("", text: value, prompt: Text(prompt).font(.system(size: 20, weight: .medium)))
                    .padding(15)
                    .background {
                        Capsule()
                            .fill(.appGray)
                    }
            } else {
                SecureField("", text: value, prompt: Text(prompt).font(.system(size: 20, weight: .medium)))
                    .padding(15)
                    .background {
                        Capsule()
                            .fill(.appGray)
                    }
            }
        }
    }
}

private extension AuthView {
    var headerView: some View {
        VStack(spacing: 20) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .padding(25)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(LinearGradient(colors: [.init(red: 42/255, green: 103/255, blue: 232/255), .init(red: 47/255, green: 140/255, blue: 188/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            
            Text("GameHub")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
    
    var authTypesView: some View {
        HStack(spacing: 20) {
            ForEach(AuthViewModel.AuthType.allCases, id: \.rawValue) { type in
                authTypeButton(type: type)
            }
        }
    }
    
    func authTypeButton(type: AuthViewModel.AuthType) -> some View {
        Button(action: viewModel.typeSelectionAction) {
            Text(type.title)
                .foregroundStyle(type == viewModel.authType ? .white : .authBackgroundGray)
                .font(.system(size: 18, weight: .semibold))
                .padding(25)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(type == viewModel.authType ? Color(red: 42/255, green: 103/255, blue: 232/255) : .appGray)
                }
        }
    }
}
