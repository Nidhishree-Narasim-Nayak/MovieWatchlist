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
    
    private var movies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    /// Loads movies from API and updates the view state and if called again it updates the next set of movies
    /// - Throws: Updates the state with an error if loading fails
    func loadMovies() async {
        
        guard !isLoading,
        currentPage <= totalPages else { return }
        isLoading = true
        if currentPage == 1 {
            state = .loading
        }
        do {
            let response = try await movieService.fetchMovies(page: currentPage)
            movies.append(contentsOf: response.results)
            totalPages = response.totalPages
            state = .loaded(movies)
            currentPage += 1
            
        } catch {
            state = .error(error.localizedDescription)
        }
        
        isLoading = false
    }
}
