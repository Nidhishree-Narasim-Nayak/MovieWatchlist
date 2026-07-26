//
//  UserDefaultsWatchlistStore.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation
import Combine

final class UserDefaultsWatchlistStore: ObservableObject, WatchlistStoreProtocol {
    @Published private(set) var movies: [Movie] = []

    private let defaults: UserDefaults
    private let storageKey = "watchlist.movies"
    
    init(defaults: UserDefaults = .standard) {
           self.defaults = defaults
           self.movies = loadFromDisk()
       }
    
    /// Checks whether a movie exists in the watchlist
    /// - Parameter movieId: The movie identifier
    /// - Returns: 'true' if the movie exists, otherwise returns 'false'
    func isInWatchlist(_ movieId: Int) -> Bool {
        movies.contains { $0.id == movieId }
    }
    
    /// Adds a movie to the watchlist
    /// - Parameter movie: The movie to add
    func add(_ movie: Movie) {
        guard !isInWatchlist(movie.id) else { return }
        movies.append(movie)
        saveToDisk()
    }
    
    /// Removes a movie from the watchlist
    /// - Parameter movieId: The identifier of the movie to remove
    func remove(_ movieId: Int) {
        movies.removeAll { $0.id == movieId }
        saveToDisk()
    }
    
    /// Saves the current watchlist to UserDefaults
    private func saveToDisk() {
        if let data = try? JSONEncoder().encode(movies) {
            defaults.set(data, forKey: storageKey)
        }
    }
    
    /// Loads the watchlist from UserDefaults
    /// - Returns: The saved watchlist or an empty array if no movies are stored
    private func loadFromDisk() -> [Movie] {
        guard let data = defaults.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Movie].self, from: data) else {
            return []
        }
        return saved
    }
}
