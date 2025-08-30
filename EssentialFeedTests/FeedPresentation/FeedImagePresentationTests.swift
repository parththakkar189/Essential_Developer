//
//  FeedImagePresentationTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2025-08-30.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

final class FeedImagePresentationTests: XCTestCase {
    
    func test_init_doesNotSendMessageToView() {
        let view = ViewSpy()
        
        _ = FeedImagePresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no messages send to view")
    }
    
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
