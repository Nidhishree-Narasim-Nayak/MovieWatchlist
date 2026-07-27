//
//  MovieWatchlistApp.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 25/07/26.
//

import SwiftUI

@main
struct MovieWatchlistApp: App {
    let coordinator = AppCoordinator()
    var body: some Scene {
        WindowGroup {
            CoordinatorView(
                controller: coordinator.makeRootViewController()
            )
        }
    }
}
