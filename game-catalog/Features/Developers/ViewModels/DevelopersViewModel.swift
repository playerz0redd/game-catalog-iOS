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
    @Published var viewState: ViewState<GamesCatalogServiceError>
    @Published var isShowingAlert = false
    
    let pushScreenAction: (_: DevelopersRouter) -> Void
    
    private let service: IGamesCatalogService
    private(set) var page: Int = 0
    
    init(service: IGamesCatalogService, pushScreenAction: @escaping (_: DevelopersRouter) -> Void) {
        self.service = service
        self.pushScreenAction = pushScreenAction
        self.viewState = .loading
        self.getDevelopers()
    }
    
    var errorMessage: LocalizedStringResource {
        if case .error(let error) = viewState {
            return error.errorDescription
        }
        return "Unknown error"
    }
    
    func getDevelopers() {
        Task {
            do {
                let developers = try await service.getDevelopers(page: getPage())
                await MainActor.run {
                    self.developers.append(contentsOf: developers.results)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.viewState = .success
                    }
                }
            } catch let error as GamesCatalogServiceError {
                self.viewState = .error(error)
                self.isShowingAlert = true
            }
        }
    }
    
    func paginateDevelopers(currentId: Int) {
        if currentId == developers[self.developers.count - 10].id, viewState != .loading {
            getDevelopers()
        }
    }
    
    private func getPage() -> Int {
        self.page += 1
        return page
    }
    
    
}
