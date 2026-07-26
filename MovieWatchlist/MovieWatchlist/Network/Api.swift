//
//  Api.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation

enum Api {
    static let baseURL = "https://api.themoviedb.org/3"
    static let bearerToken = Bundle.main.tmdbAPIToken

    enum Endpoint: String {
        case trendingMovies = "/trending/movie/day"
        case movieDetail = "/movie"
    }

    enum QueryKey: String {
        case language
        case page
    }
}

extension Bundle {
    var tmdbAPIToken: String {
        object(forInfoDictionaryKey: "TMDB_API_TOKEN") as? String ?? ""
    }
}
