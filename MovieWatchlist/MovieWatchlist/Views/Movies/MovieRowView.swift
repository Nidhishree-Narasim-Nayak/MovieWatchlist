//
//  MovieRowView.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 27/07/26.
//
import SwiftUI

struct MovieRowView: View {
    let movie: Movie

    var body: some View {
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
