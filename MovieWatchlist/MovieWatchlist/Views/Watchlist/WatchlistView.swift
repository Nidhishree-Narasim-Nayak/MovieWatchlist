//
//  WatchlistView.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 25/07/26.
//

import SwiftUI

struct WatchlistView: View {
    @StateObject private var viewModel: WatchlistViewModel
    let onSelectMovie: (Movie) -> Void

    init(
        watchlistStore: WatchlistStoreProtocol,
        onSelectMovie: @escaping (Movie) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: WatchlistViewModel(watchlistStore: watchlistStore))
        self.onSelectMovie = onSelectMovie
    }

    var body: some View {
        content
            .navigationTitle("Watchlist")
            .onAppear {
                viewModel.refresh()
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.movies.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "bookmark")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                Text("Your watchlist is empty")
                    .foregroundColor(.secondary)
            }
        } else {
            List(viewModel.movies) { movie in
                Button {
                    onSelectMovie(movie)
                } label: {
                    MovieRowView(movie: movie)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets())
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
    }
}
