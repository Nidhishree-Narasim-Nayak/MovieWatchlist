//
//  ApiError.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation
enum ApiError: Error, LocalizedError {
    case badURL
    case badResponse(String)
    case decodingError
    
    var errorDescription: String {
        switch self {
        case .badURL: return "Invalid URL"
        case .badResponse(let message): return message
        case .decodingError: return "Failed to decode data"
        }
    }
}

struct TMDBErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
}
