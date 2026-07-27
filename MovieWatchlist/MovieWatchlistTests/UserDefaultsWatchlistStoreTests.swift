//
//  UserDefaultsWatchlistStoreTests.swift
//  MovieWatchlistTests
//
//  Created by Nidhishree Nayak on 27/07/26.
//

import XCTest
@testable import MovieWatchlist

final class UserDefaultsWatchlistStoreTests: XCTestCase {
    private var defaults: UserDefaults?
    private let testUserDefaultsName = "com.movieWatchlist.tests.watchlist"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        guard let defaults = UserDefaults(suiteName: testUserDefaultsName) else {
            XCTFail("Failed to create test UserDefaults")
            return
        }
        
        self.defaults = defaults
        defaults.removePersistentDomain(forName: testUserDefaultsName)
    }
    
    override func tearDownWithError() throws {
        defaults?.removePersistentDomain(forName: testUserDefaultsName)
        defaults = nil
        try super.tearDownWithError()
    }
    
    private func makeMovie(id: Int = 1, title: String = "Avatar") -> Movie {
        Movie(
            id: id,
            title: title,
            overview: "A sci-fi epic",
            posterPath: nil,
            releaseDate: "2009-10-22",
            voteAverage: 8.0
        )
    }
    
    func test_initialState_isEmpty() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        XCTAssertTrue(store.movies.isEmpty)
    }
    
    func test_add_insertsMovie() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        let movie = makeMovie()
        
        store.add(movie)
        
        XCTAssertTrue(store.isInWatchlist(movie.id))
        XCTAssertEqual(store.movies, [movie])
    }
    
    func test_add_sameMovieTwice_doesNotDuplicate() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        let movie = makeMovie()
        
        store.add(movie)
        store.add(movie)
        
        XCTAssertEqual(store.movies.count, 1)
    }
    
    func test_remove_deletesMovie() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        let movie = makeMovie()
        
        store.add(movie)
        store.remove(movie.id)
        
        XCTAssertFalse(store.isInWatchlist(movie.id))
        XCTAssertTrue(store.movies.isEmpty)
    }
    
    func test_remove_nonExistentMovie_doesNothing() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        
        store.add(makeMovie(id: 1))
        store.remove(999)
        
        XCTAssertEqual(store.movies.count, 1)
    }
    
    func test_isInWatchlist_whenNotAdded_returnsFalse() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        
        XCTAssertFalse(store.isInWatchlist(999))
    }
    
    func test_persistence_survivesAcrossInstances() throws {
        let defaults = try XCTUnwrap(defaults)
        let movie = makeMovie()
        
        let firstInstance = UserDefaultsWatchlistStore(defaults: defaults)
        firstInstance.add(movie)
        
        let secondInstance = UserDefaultsWatchlistStore(defaults: defaults)
        
        XCTAssertEqual(secondInstance.movies, [movie])
        XCTAssertTrue(secondInstance.isInWatchlist(movie.id))
    }
    
    func test_addThenRemove_thenAddAgain_worksCorrectly() throws {
        let defaults = try XCTUnwrap(defaults)
        let store = UserDefaultsWatchlistStore(defaults: defaults)
        let movie = makeMovie()
        
        store.add(movie)
        store.remove(movie.id)
        store.add(movie)
        
        XCTAssertEqual(store.movies, [movie])
    }
}
