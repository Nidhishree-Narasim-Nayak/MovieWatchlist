//
//  Appcoordinator.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 25/07/26.
//

import UIKit
import SwiftUI

final class Appcoordinator {
    let navigationController = UINavigationController()
    
    /// Sets up the initial tab bar interface with Movies and Watchlist tabs.
    /// - Returns: Returns a view controller containing the main app navigation.
    func makeRootViewController() -> UIViewController {
        let tabBarController = UITabBarController()
        let moviesView = MoviesView()
        let moviesVC = UIHostingController(rootView: moviesView)
        moviesVC.tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "film"),
            selectedImage: nil
        )
        
        let watchlistView = WatchlistView()
        let watchlistVC = UIHostingController(rootView: watchlistView)
        watchlistVC.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(systemName: "bookmark"),
            selectedImage: nil
        )
        
        tabBarController.viewControllers = [moviesVC, watchlistVC]
        return tabBarController
    }
}
