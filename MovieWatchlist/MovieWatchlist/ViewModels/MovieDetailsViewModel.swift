//
//  MovieDetailsViewModel.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation
import Combine

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(MovieDetail)
        case error(String)
    }
    
    @Published private(set) var state: State = .loading
    @Published private(set) var isInWatchlist: Bool
    
    private let movie: Movie
    private let movieService: MovieServiceProtocol
    private let watchlistStore: WatchlistStoreProtocol
    
    init(
        movie: Movie,
        movieService: MovieServiceProtocol,
        watchlistStore: WatchlistStoreProtocol
    ) {
        self.movie = movie
        self.movieService = movieService
        self.watchlistStore = watchlistStore
        self.isInWatchlist = watchlistStore.isInWatchlist(movie.id)
    }
    
    /// Loads details for the selected movie
    /// - Throws: Updates the state with an error if loading fails
    func loadDetails() async {
        state = .loading
        do {
            let detail = try await movieService.fetchMovieDetail(movieId: movie.id)
            state = .loaded(detail)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    /// Adds or removes the current movie from the watchlist
    func toggleWatchlist() {
        if isInWatchlist {
            watchlistStore.remove(movie.id)
        } else {
            watchlistStore.add(movie)
        }
        isInWatchlist = watchlistStore.isInWatchlist(movie.id)
    }
}
