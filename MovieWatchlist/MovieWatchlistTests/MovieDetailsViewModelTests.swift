//
//  MovieDetailsViewModelTests.swift
//  MovieWatchlistTests
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import XCTest
@testable import MovieWatchlist

@MainActor
final class MovieDetailsViewModelTests: XCTestCase {

    private func makeMovie(id: Int = 1, title: String = "Avatar") -> Movie {
        Movie(
            id: id,
            title: title,
            overview: "A sci-fi movie",
            posterPath: nil,
            releaseDate: "2009-12-18",
            voteAverage: 8.0
        )
    }

    private func makeMovieDetail(id: Int = 1, title: String = "Avatar") -> MovieDetail {
        MovieDetail(
            id: id,
            title: title,
            overview: "A sci-fi movie",
            posterPath: nil,
            releaseDate: "2009-12-18",
            runtime: 162,
            voteAverage: 8.0
        )
    }

    /// Verifies that a movie is not in the watchlist when the view model is created
    func test_initialState_movieIsNotInWatchlist() {
        let service = MockMovieService()
        let store = MockWatchlistStore()
        let movie = makeMovie()
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieService: service,
            watchlistStore: store
        )
        XCTAssertFalse(viewModel.isInWatchlist)
    }

    /// Verifies that a movie is already in the watchlist when the view model is created
    func test_initialState_movieIsInWatchlist() {
        let service = MockMovieService()
        let store = MockWatchlistStore()
        let movie = makeMovie()
        store.add(movie)
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieService: service,
            watchlistStore: store
        )
        XCTAssertTrue(viewModel.isInWatchlist)
    }

    /// Verifies that movie details are loaded successfully
    func test_loadDetails_successfullyLoadsMovieDetails() async {
        let service = MockMovieService()
        let store = MockWatchlistStore()
        let movie = makeMovie()
        service.movieDetail = makeMovieDetail()
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieService: service,
            watchlistStore: store
        )
        await viewModel.loadDetails()
        switch viewModel.state {
        case .loaded(let detail):
            XCTAssertEqual(detail.id, movie.id)
            XCTAssertEqual(detail.title, "Avatar")

        default:
            XCTFail("Expected loaded state")
        }
    }

    /// Verifies that an error state is returned when loading movie details fails
    func test_loadDetails_whenServiceFails_returnsError() async {
        let service = MockMovieService()
        let store = MockWatchlistStore()
        let movie = makeMovie()
        service.shouldThrowError = true
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieService: service,
            watchlistStore: store
        )
        await viewModel.loadDetails()
        switch viewModel.state {
        case .error:
            XCTAssertTrue(true)

        default:
            XCTFail("Expected error state")
        }
    }

    /// Verifies that toggling the watchlist adds the movie
    func test_toggleWatchlist_addsMovie() {
        let service = MockMovieService()
        let store = MockWatchlistStore()
        let movie = makeMovie()
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieService: service,
            watchlistStore: store
        )
        viewModel.toggleWatchlist()
        XCTAssertTrue(viewModel.isInWatchlist)
        XCTAssertTrue(store.isInWatchlist(movie.id))
    }

    /// Verifies that toggling the watchlist removes the movie
    func test_toggleWatchlist_removesMovie() {

        let service = MockMovieService()
        let store = MockWatchlistStore()
        let movie = makeMovie()
        store.add(movie)
        let viewModel = MovieDetailsViewModel(
            movie: movie,
            movieService: service,
            watchlistStore: store
        )
        viewModel.toggleWatchlist()
        XCTAssertFalse(viewModel.isInWatchlist)
        XCTAssertFalse(store.isInWatchlist(movie.id))
    }
}
