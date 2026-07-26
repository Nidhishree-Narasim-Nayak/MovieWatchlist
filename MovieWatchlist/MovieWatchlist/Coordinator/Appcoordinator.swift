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
        let movieService = TMDBMovieService()
        let watchlistStore = UserDefaultsWatchlistStore()
        let moviesNav = UINavigationController()
        let moviesView = MoviesView(movieService: movieService) { [weak moviesNav] movie in
            let detailView = MovieDetailsView(
                movie: movie,
                movieService: movieService,
                watchlistStore: watchlistStore
            )
            let detailVC = UIHostingController(rootView: detailView)
            moviesNav?.pushViewController(detailVC, animated: true)
        }
        let moviesVC = UIHostingController(rootView: moviesView)
        moviesNav.viewControllers = [moviesVC]
        moviesNav.tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "film"),
            selectedImage: nil
        )
        
        let watchlistView = WatchlistView()
        let watchlistVC = UIHostingController(rootView: watchlistView)
        let watchlistNav = UINavigationController(rootViewController: watchlistVC)
        watchlistNav.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(systemName: "bookmark"),
            selectedImage: nil
        )
        
        tabBarController.viewControllers = [moviesNav, watchlistNav]
        return tabBarController
    }
}
