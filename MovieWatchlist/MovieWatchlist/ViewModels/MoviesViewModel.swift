//
//  MoviesViewModel.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation
import Combine

@MainActor
final class MoviesViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([Movie])
        case error(String)
    }
    
    @Published private(set) var state: State = .loading
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol) {
        self .movieService = movieService
    }
    
    /// Loads trending movies and updates the view state
    /// - Throws: Updates the state with an error if loading fails
    func loadMovies() async {
        state = .loading
        do {
            let movies = try await movieService.fetchMovies(page: 1)
            state = .loaded(movies)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
