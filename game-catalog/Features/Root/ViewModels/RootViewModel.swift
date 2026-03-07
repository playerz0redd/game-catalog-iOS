//
//  RootViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 1.03.26.
//

import Foundation
import Combine

final class RootViewModel: ObservableObject {
    
    @Published var isSigned: Bool = false
    @Published var isShowingSplash: Bool = true
    
    private let authService: IAuthService
    private var cancellables: Set<AnyCancellable> = []
    
    init(authService: IAuthService) {
        self.authService = authService
        
        self.authService.isAuthorizedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.self.isSigned, on: self)
            .store(in: &cancellables)
    }
}
