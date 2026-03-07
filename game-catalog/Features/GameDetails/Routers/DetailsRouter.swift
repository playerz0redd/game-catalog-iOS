//
//  DetailsRouter.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 19.02.26.
//

import Foundation
import SwiftUI

enum DetailsRouter: Hashable, IRouter {
    
    case movieDescription(description: String, ageRating: String)
    case allScreenshots(screenshots: [ScreenshotModel])
    case allVideos(trailers: [GameVideoModel])
    case allDevelopers(developers: [CreatorModel])
    case allStores
    case allPlatforms
    
    @ViewBuilder
    func getView() -> some View {
        switch self {
        case .movieDescription(let description, let ageRating):
            DescriptionView(desctiption: description, ageRating: ageRating)
        case .allScreenshots(let screenshots):
            AllItemsView(items: screenshots, title: self.viewTitle)
        case .allVideos(let trailers):
            AllItemsView(items: trailers, title: self.viewTitle)
        case .allDevelopers(let developers):
            AllItemsView(items: developers, title: self.viewTitle)
        case .allStores:
            Text("new")
        case .allPlatforms:
            Text("new")
        }
    }
    
    var viewTitle: LocalizedStringResource {
        switch self {
        case .movieDescription:
            "Description"
        case .allScreenshots:
            "Screenshots"
        case .allVideos:
            "Movies"
        case .allDevelopers:
            "Developers"
        case .allStores:
            "Stores"
        case .allPlatforms:
            "Platforms"
        }
    }
}
