//
//  MoviesViewModelTests.swift
//  MovieWatchlistTests
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import XCTest
@testable import MovieWatchlist

@MainActor
final class MoviesViewModelTests: XCTestCase {
    
    /// Creates a sample movie for testing
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
    
    /// Verifies that the initial state is loading
    func test_initialState_isLoading() {
        let service = MockMovieService()
        let viewModel = MoviesViewModel(movieService: service)
        switch viewModel.state {
        case .loading:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected loading state")
        }
    }
    
    /// Verifies that movies are loaded successfully
    func test_loadMovies_successfullyLoadsMovies() async {
        let service = MockMovieService()
        service.movieResponse = MovieResponse(
            page: 1,
            results: [
                makeMovie()
            ],
            totalPages: 2,
            totalResults: 1
        )
        let viewModel = MoviesViewModel(movieService: service)
        await viewModel.loadMovies()
        switch viewModel.state {
        case .loaded(let movies):
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.title, "Avatar")

        default:
            XCTFail("Expected loaded state")
        }
    }
    
    /// Verifies that an error state is returned when loading movies fails
    func test_loadMovies_whenServiceFails_returnsError() async {
        let service = MockMovieService()
        service.shouldThrowError = true
        let viewModel = MoviesViewModel(movieService: service)
        await viewModel.loadMovies()
        switch viewModel.state {
        case .error:
            XCTAssertTrue(true)

        default:
            XCTFail("Expected error state")
        }
    }
    
    /// Verifies that movies from the next page are appended to the existing list
    func test_loadMovies_appendsNextPageMovies() async {
        let service = MockMovieService()
        service.movieResponse = MovieResponse(
            page: 1,
            results: [
                makeMovie(id: 1, title: "Avatar")
            ],
            totalPages: 2,
            totalResults: 2
        )
        let viewModel = MoviesViewModel(movieService: service)
        await viewModel.loadMovies()
        service.movieResponse = MovieResponse(
            page: 2,
            results: [
                makeMovie(id: 2, title: "Inception")
            ],
            totalPages: 2,
            totalResults: 2
        )

        await viewModel.loadMovies()
        switch viewModel.state {
        case .loaded(let movies):
            XCTAssertEqual(movies.count, 2)
            XCTAssertEqual(movies[0].title, "Avatar")
            XCTAssertEqual(movies[1].title, "Inception")

        default:
            XCTFail("Expected loaded state")
        }
    }
    
    /// Verifies that no more movies are loaded after the last page
    func test_loadMovies_stopsLoadingAfterLastPage() async {
        let service = MockMovieService()
        service.movieResponse = MovieResponse(
            page: 1,
            results: [
                makeMovie()
            ],
            totalPages: 1,
            totalResults: 1
        )

        let viewModel = MoviesViewModel(movieService: service)
        await viewModel.loadMovies()
        await viewModel.loadMovies()
        switch viewModel.state {
        case .loaded(let movies):
            XCTAssertEqual(movies.count, 1)

        default:
            XCTFail("Expected loaded state")
        }
    }
}
