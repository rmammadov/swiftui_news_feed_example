//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Rahman Mammadov on 29.09.23.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @StateObject var feedViewModel = FeedViewModel()
    
    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: feedViewModel)
        }
    }
}
