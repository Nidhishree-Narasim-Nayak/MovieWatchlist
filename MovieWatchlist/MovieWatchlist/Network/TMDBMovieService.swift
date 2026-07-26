//
//  TMDBMovieService.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchTrendingMovies(page: Int) async throws -> [Movie]
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
    
    /// Fetches a page of trending movies
    /// - Parameter page: The page number to fetch
    /// - Returns: An array of trending movies
    /// - Throws: An error if the request fails
    func fetchTrendingMovies(page: Int) async throws -> [Movie] {
        guard var components = URLComponents(string: Api.baseURL + Api.Endpoint.trendingMovies.rawValue) else {
            throw ApiError.badURL
        }
            components.queryItems = [
                URLQueryItem(name: Api.QueryKey.language.rawValue, value: "en-US"),
                URLQueryItem(name: Api.QueryKey.page.rawValue, value: "\(page)")
            ]
        guard let url = components.url else { throw ApiError.badURL }
        let response: MovieResponse = try await client.get(url: url, headers: authHeaders)
        
        return response.results
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
