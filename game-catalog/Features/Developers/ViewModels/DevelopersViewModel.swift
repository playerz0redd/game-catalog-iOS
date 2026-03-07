//
//  DevelopersViewModel.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 26.02.26.
//

import Foundation
import Combine

final class DevelopersViewModel: ObservableObject {
    
    @Published var developers: [DeveloperModel] = []
    @Published var selectedDeveloperId: Int?
    
    let pushScreenAction: (_: DevelopersRouter) -> Void
    
    private let service: IGamesCatalogService
    private(set) var page: Int = 0
    private var isLoading = false
    
    init(service: IGamesCatalogService, pushScreenAction: @escaping (_: DevelopersRouter) -> Void) {
        self.service = service
        self.pushScreenAction = pushScreenAction
        self.getDevelopers()
    }
    
    func getDevelopers() {
        isLoading = true
        Task {
            let developers = try await service.getDevelopers(page: getPage())
            await MainActor.run {
                self.developers.append(contentsOf: developers.results)
                isLoading = false
            }
        }
    }
    
    func paginateDevelopers(currentId: Int) {
        if currentId == developers[self.developers.count - 10].id, !isLoading {
            getDevelopers()
        }
    }
    
    private func getPage() -> Int {
        self.page += 1
        return page
    }
    
    
}
