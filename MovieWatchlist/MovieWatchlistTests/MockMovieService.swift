//
//  MockMovieService.swift
//  MovieWatchlistTests
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import Foundation
@testable import MovieWatchlist

/// A mock implementation of MovieServiceProtocol used for unit testing
final class MockMovieService: MovieServiceProtocol {

    var movieResponse = MovieResponse(
        page: 1,
        results: [],
        totalPages: 1,
        totalResults: 0
    )

    var movieDetail = MovieDetail(
        id: 1,
        title: "Avatar",
        overview: "A sci-fi movie",
        posterPath: nil,
        releaseDate: "2009-12-18",
        runtime: 162,
        voteAverage: 8.0
    )

    var shouldThrowError = false

    enum MockError: Error {
        case failed
    }
    
    /// Returns a mock movie response for testing
    /// - Parameter page: The page number requested
    /// - Returns: A mock MovieResponse
    /// - Throws: MockError.failed when shouldThrowError is true
    func fetchMovies(page: Int) async throws -> MovieResponse {
        if shouldThrowError {
            throw MockError.failed
        }
        return movieResponse
    }
    
    /// Returns mock movie details for testing
    /// - Parameter movieId: The identifier of the requested movie
    /// - Returns: A mock MovieDetail
    /// - Throws: MockError.failed when shouldThrowError is true
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        if shouldThrowError {
            throw MockError.failed
        }
        return movieDetail
    }
}
