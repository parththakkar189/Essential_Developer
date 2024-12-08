//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2024-12-08.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}


final class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCachedUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
