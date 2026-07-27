//
//  TMDBMovieService.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(page: Int) async throws -> MovieResponse
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail
}

final class TMDBMovieService: MovieServiceProtocol {
    private let client = ApiClient()
    private var authHeaders: [String: String] {
        [
            "Authorization": "Bearer \(Api.bearerToken)",
            "accept": "application/json"
        ]
    }
    
    /// Fetches a page of movies from the Discover API which is sorted by popularity
    /// - Parameter page: The page number to fetch
    /// - Returns: An array of movies
    /// - Throws: An error if the request fails
    func fetchMovies(page: Int) async throws -> MovieResponse {
        guard var components = URLComponents(string: Api.baseURL + Api.Endpoint.discoverMovies.rawValue) else {
            throw ApiError.badURL
        }
            components.queryItems = [
                URLQueryItem(name: Api.QueryKey.language.rawValue, value: "en-US"),
                URLQueryItem(name: Api.QueryKey.page.rawValue, value: "\(page)"),
                URLQueryItem(name: Api.QueryKey.sortBy.rawValue, value: "popularity.desc")
            ]
        guard let url = components.url else { throw ApiError.badURL }
        
        return try await client.get(url: url, headers: authHeaders)
    }
    
    /// Fetches details for a specific movie
    /// - Parameter movieId: The unique movie identifier
    /// - Returns: The movie details
    /// - Throws: An error if the request fails
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetail {
        guard var components = URLComponents(string: Api.baseURL + Api.Endpoint.movieDetail.rawValue + "/\(movieId)") else {
                  throw ApiError.badURL
              }
        components.queryItems = [
                   URLQueryItem(name: Api.QueryKey.language.rawValue, value: "en-US")
               ]
        guard let url = components.url else { throw ApiError.badURL }
        
        return try await client.get(url: url, headers: authHeaders)
    }
}
