//
//  MockWatchlistStore.swift
//  MovieWatchlistTests
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import Foundation
@testable import MovieWatchlist

/// A mock implementation of WatchlistStoreProtocol used for unit testing
final class MockWatchlistStore: WatchlistStoreProtocol {
    var movies: [Movie] = []
    
    /// Checks whether a movie exists in the mock watchlist
    /// - Parameter movieId: The identifier of the movie
    /// - Returns: Returns true if the movie exists, otherwise false
    func isInWatchlist(_ movieId: Int) -> Bool {
        movies.contains { $0.id == movieId }
    }
    
    /// Adds a movie to the mock watchlist
    /// - Parameter movie: The movie to add
    func add(_ movie: Movie) {
        movies.append(movie)
    }
    
    /// Removes a movie from the mock watchlist
    /// - Parameter movieId: The identifier of the movie to remove
    func remove(_ movieId: Int) {
        movies.removeAll { $0.id == movieId }
    }
}
