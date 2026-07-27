//
//  MovieDetailsView.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 26/07/26.
//

import SwiftUI

struct MovieDetailsView: View {
    @StateObject private var viewModel: MovieDetailsViewModel
    
    init(
        movie: Movie,
        movieService: MovieServiceProtocol,
        watchlistStore: WatchlistStoreProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: MovieDetailsViewModel(
                movie: movie,
                movieService: movieService,
                watchlistStore: watchlistStore
            )
        )
    }
    
    var body: some View {
        content
            .task {
                await viewModel.loadDetails()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading details...")
            
        case .loaded(let detail):
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AsyncImage(url: detail.posterURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(detail.title)
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(String(format: "%.1f", detail.voteAverage))/10")
                        if let runtime = detail.runtime {
                            Text("• \(runtime) min")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(detail.overview)
                        .font(.body)
                    
                    watchlistButton
                }
                .padding()
            }
            .navigationTitle(detail.title)
            .navigationBarTitleDisplayMode(.inline)
            
        case .error(let message):
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Text(message)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var watchlistButton: some View {
        Button {
            viewModel.toggleWatchlist()
        } label: {
            HStack {
                Image(
                    systemName: viewModel.isInWatchlist ?
                    "bookmark.fill" :
                        "bookmark"
                )
                Text(
                    viewModel.isInWatchlist ?
                    "Remove from Watchlist" :
                        "Add to Watchlist"
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isInWatchlist ? Color.gray.opacity(0.2) : Color.blue)
            .foregroundColor(viewModel.isInWatchlist ? .primary : .white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.top, 8)
    }
}
