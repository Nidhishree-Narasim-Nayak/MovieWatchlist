//
//  WatchlistStoreProtocol.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import Foundation

protocol WatchlistStoreProtocol: AnyObject {
    var movies: [Movie] { get }
    func isInWatchlist(_ movieId: Int) -> Bool
    func add(_ movie: Movie)
    func remove(_ movieId: Int)
}
