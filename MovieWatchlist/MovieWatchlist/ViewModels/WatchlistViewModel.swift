//
//  WatchlistViewModel.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import Foundation
import Combine

@MainActor
final class WatchlistViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    
    private let watchlistStore: WatchlistStoreProtocol
    
    init(watchlistStore: WatchlistStoreProtocol) {
        self.watchlistStore = watchlistStore
    }
    
    /// Refreshes the watchlist from the store
    func refresh() {
        movies = watchlistStore.movies
    }
}
