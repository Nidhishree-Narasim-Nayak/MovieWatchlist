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
                        row(for: movie)
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
    
    /// Builds a single tappable row for a movie in a list
    /// - Parameter movie: The movie to display in the row
    /// - Returns: A view representing the movie's poster, title, release year, and rating
    private func row(for movie: Movie) -> some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                
                Text(movie.releaseDate?.prefix(4) ?? "Unknown Release Date")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text("\(String(format: "%.1f", movie.voteAverage))/10")
                        .font(.subheadline)
                }
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
