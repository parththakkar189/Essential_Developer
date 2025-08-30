//
//  FeedPresentationTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2025-08-30.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

final class FeedPresentationTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
