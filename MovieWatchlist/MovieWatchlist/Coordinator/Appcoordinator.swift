//
//  Appcoordinator.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 25/07/26.
//

import UIKit
import SwiftUI

final class AppCoordinator {

    private let movieService = TMDBMovieService()
    private let watchlistStore = UserDefaultsWatchlistStore()

    /// Creates the root tab bar controller for the application
    /// - Returns: The application's root view controller
    func makeRootViewController() -> UIViewController {

        let tabBarController = UITabBarController()

        tabBarController.viewControllers = [
            makeMoviesNavigationController(),
            makeWatchlistNavigationController()
        ]

        return tabBarController
    }

    /// Creates the Movies tab navigation controller
    /// - Returns: A navigation controller containing the Movies screen
    private func makeMoviesNavigationController() -> UINavigationController {

        let navigationController = UINavigationController()
        let moviesView = MoviesView(
            movieService: movieService
        ) { [weak navigationController] movie in
            let detailController = self.makeMovieDetailsController(movie)
            navigationController?.pushViewController(
                detailController,
                animated: true
            )
        }

        let hostingController = UIHostingController(
            rootView: moviesView
        )
        hostingController.title = "Movies"
        navigationController.viewControllers = [
            hostingController
        ]
        navigationController.tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "film"),
            selectedImage: nil
        )

        return navigationController
    }

    /// Creates the Watchlist tab navigation controller
    /// - Returns: A navigation controller containing the Watchlist screen
    private func makeWatchlistNavigationController() -> UINavigationController {

        let navigationController = UINavigationController()
        let watchlistView = WatchlistView(
            watchlistStore: watchlistStore
        ) { [weak navigationController] movie in
            let detailController = self.makeMovieDetailsController(movie)
            navigationController?.pushViewController(
                detailController,
                animated: true
            )
        }

        let hostingController = UIHostingController(
            rootView: watchlistView
        )
        hostingController.title = "Watchlist"
        navigationController.viewControllers = [
            hostingController
        ]

        navigationController.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(systemName: "bookmark"),
            selectedImage: nil
        )
        
        return navigationController
    }

    /// Creates the movie details screen for the selected movie
    /// - Parameter movie: The selected movie
    /// - Returns: A view controller displaying the movie details
    private func makeMovieDetailsController(
        _ movie: Movie
    ) -> UIViewController {
        let detailView = MovieDetailsView(
            movie: movie,
            movieService: movieService,
            watchlistStore: watchlistStore
        )

        return UIHostingController(
            rootView: detailView
        )
    }
}
