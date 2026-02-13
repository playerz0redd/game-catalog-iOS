//
//  SafariView.swift
//  game-catalog
//
//  Created by Pavel Playerz0redd on 13.02.26.
//

import SafariServices
import SwiftUI


struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) { }
    
}
