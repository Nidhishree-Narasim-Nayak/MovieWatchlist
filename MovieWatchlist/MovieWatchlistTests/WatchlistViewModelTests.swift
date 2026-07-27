//
//  WatchlistViewModelTests.swift
//  MovieWatchlistTests
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import XCTest
@testable import MovieWatchlist

@MainActor
final class WatchlistViewModelTests: XCTestCase {
    
    /// Creates a sample movie for testing
    private func makeMovie(id: Int = 1, title: String = "Avatar") -> Movie {
        Movie(
            id: id,
            title: title,
            overview: "A sci-fi epic",
            posterPath: nil,
            releaseDate: "2009-10-22",
            voteAverage: 8.0
        )
    }
    
    /// Verifies that the watchlist is empty when the view model is created
    func test_initialState_isEmpty() {
        let store = MockWatchlistStore()
        let viewModel = WatchlistViewModel(watchlistStore: store)
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    /// Verifies that refreshing updates the watchlist with the store contents
    func test_refresh_reflectsStoreContents() {
         let store = MockWatchlistStore()
         let movie = makeMovie()
         store.movies = [movie]
         let viewModel = WatchlistViewModel(watchlistStore: store)
         viewModel.refresh()
         XCTAssertEqual(viewModel.movies, [movie])
     }
    
    /// Verifies that refreshing returns an empty watchlist when the store is empty
    func test_refresh_whenStoreEmpty_returnsEmptyMovies() {
        let store = MockWatchlistStore()
        let viewModel = WatchlistViewModel(watchlistStore: store)
        viewModel.refresh()
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    /// Verifies that refreshing updates the watchlist after a movie is removed
    func test_refresh_afterMovieRemoved_updatesList() {
        let store = MockWatchlistStore()
        let movie = makeMovie()
        store.movies = [movie]
        let viewModel = WatchlistViewModel(watchlistStore: store)
        viewModel.refresh()
        XCTAssertEqual(viewModel.movies.count, 1)
        store.remove(movie.id)
        viewModel.refresh()
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    /// Verifies that refreshing preserves the order of multiple movies
    func test_refresh_withMultipleMovies_preservesOrder() {
        let store = MockWatchlistStore()
        let movie1 = makeMovie(id: 1, title: "Avatar")
        let movie2 = makeMovie(id: 2, title: "3 idiots")
        store.movies = [movie1, movie2]
        let viewModel = WatchlistViewModel(watchlistStore: store)
        viewModel.refresh()
        XCTAssertEqual(viewModel.movies, [movie1, movie2])
    }
}
