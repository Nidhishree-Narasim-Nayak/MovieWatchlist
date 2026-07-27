//
//  ContentView.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 25/07/26.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel: MoviesViewModel
    let onSelectMovie: (Movie) -> Void
    
    init(
        movieService: MovieServiceProtocol,
        onSelectMovie: @escaping (Movie) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: MoviesViewModel(movieService: movieService))
        self.onSelectMovie = onSelectMovie
    }
    
    var body: some View {
        content
            .navigationTitle("Movies")
            .task {
                await viewModel.loadMovies()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        Group {
            switch viewModel.state {
                
            case .loading:
                ProgressView("Loading movies...")
                
            case .loaded(let movies):
                List(movies) { movie in
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
                
            case .error(let message):
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    
                    Text(message)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
