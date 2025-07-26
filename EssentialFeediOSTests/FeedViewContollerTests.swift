//
//  FeedViewContollerTests.swift
//  EssentialFeediOSTests
//
//  Created by Parth Thakkar on 2025-07-26.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewContollerTests.LoaderSpy) {
        
    }
}

final class FeedViewContollerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - LoaderSpy
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
