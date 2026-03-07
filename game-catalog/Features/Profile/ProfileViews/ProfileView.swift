//
//  ProfileView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 2.03.26.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel: ProfileViewModel = .init(
        profileService:
            ProfileService(
                storageManager: StorageManager(),
                authManager: AuthManager()
            )
    )
    
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        
        VStack(spacing: 15) {
            userImage
            
            profileDescription
            
            actionButton(title: "Change language") {
                if languageManager.selectedLanguage == "ru" {
                    languageManager.selectedLanguage = "en"
                } else {
                    languageManager.selectedLanguage = "ru"
                }
            }
            
            actionButton(title: "Sign out", action: viewModel.signOut)
            
        }
        .padding(.horizontal, 30)
        .confirmationDialog("Change Photo", isPresented: $viewModel.isShowingDialog) {
            Button("Camera") {
                viewModel.sourceType = .camera
                viewModel.isShowingCamera = true
            }
            Button("Photo Library") {
                viewModel.sourceType = .photoLibrary
                viewModel.isShowingPicker = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowingCamera) {
            ImagePicker(image: $viewModel.uiImage, sourceType: viewModel.sourceType)
                .ignoresSafeArea(.all)
        }
        .sheet(isPresented: $viewModel.isShowingPicker) {
            ImagePicker(image: $viewModel.uiImage, sourceType: viewModel.sourceType)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ProfileView {
    func actionButton(title: LocalizedStringResource, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(LinearGradient(colors: [.init(red: 42/255, green: 103/255, blue: 232/255), .init(red: 47/255, green: 140/255, blue: 188/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                }
        }
    }
}

private extension ProfileView {
    var profileDescription: some View {
        VStack(spacing: 20) {
            Text(viewModel.user?.name ?? "No Name")
                .font(.system(size: 30, weight: .semibold))
            
            Text(viewModel.user?.email ?? "No Email")
                .font(.system(size: 25, weight: .semibold))
        }
        .foregroundStyle(.white)
    }
}

private extension ProfileView {
    
    var deletePhotoView: some View {
        Button(action: viewModel.deleteImage) {
            Image(systemName: "xmark")
                .padding(5)
                .font(.system(size: 23))
                .foregroundStyle(.white)
                .background(Circle().fill(Color.red))
        }
    }
    
    @ViewBuilder
    var userImage: some View {
        if let image = viewModel.uiImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .foregroundStyle(.blue)
                .clipShape(Circle())
                .onTapGesture {
                    viewModel.isShowingDialog = true
                }
                .overlay(alignment: .topTrailing) {
                    deletePhotoView
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                }
        } else {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .foregroundStyle(.blue)
                .clipShape(Circle())
                .onTapGesture {
                    viewModel.isShowingDialog = true
                }
        }
        
    }
}
