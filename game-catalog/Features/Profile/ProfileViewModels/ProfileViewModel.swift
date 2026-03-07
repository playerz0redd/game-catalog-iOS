//
//  ProfileViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 2.03.26.
//

import Foundation
import Combine
import UIKit

final class ProfileViewModel: ObservableObject {
    
    @Published var isShowingCamera: Bool = false
    @Published var isShowingPicker: Bool = false
    @Published var isShowingGallery: Bool = false
    @Published var isShowingDialog: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .camera
    @Published var uiImage: UIImage?
    @Published var user: UserProfileModel?
    
    
    private let profileService: IProfileService
    private let imageName = "avatar"
    private var cancellables: [AnyCancellable] = []
    
    init(profileService: IProfileService) {
        self.profileService = profileService
        initializeImage()
        getUser()
        
        self._uiImage.projectedValue.sink { image in
            self.onImageChange(image: image)
        }
        .store(in: &cancellables)

    }
    
    
    private func getUser() {
        user = profileService.getUser()
    }
    
    private func initializeImage() {
        self.uiImage = profileService.fetchPhoto(name: imageName)
    }
    
    private func onImageChange(image: UIImage?) {
        do {
            if let image = image {
                try profileService.savePhoto(image: image, name: imageName)
            } else {
                try profileService.deletePhoto(name: imageName)
            }
        } catch let error {
            
        }
    }
    
    func deleteImage() {
        do {
            uiImage = nil
            try profileService.deletePhoto(name: imageName)
            
        } catch let error {
            
        }
    }
    
    func signOut() {
        Task {
            do {
                try profileService.signOut()
            } catch let error {
                
            }
        }
    }
}
