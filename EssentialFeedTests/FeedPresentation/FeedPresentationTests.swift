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
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let presenter = FeedPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(presenter, file: file, line: line)
        return (presenter, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
