//
//  ApiClient.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation

final class ApiClient {
    
    /// Performs a GET request and decodes the response.
    /// - Parameters:
    ///   - url: The endpoint url
    ///   - headers: HTTP headers to include in the request
    /// - Returns: The decoded response of type `T`
    /// - Throws: `ApiError` if the request fails or decoding is unsuccessful.
    func get<T: Decodable>(url: URL, headers: [String: String] = [:]) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.badResponse("No response from server.")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let tmdbError = try? JSONDecoder().decode(TMDBErrorResponse.self, from: data) {
                throw ApiError.badResponse(tmdbError.statusMessage)
            }
            throw ApiError.badResponse("Something went wrong. Please try again")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError.decodingError
        }
    }
}
