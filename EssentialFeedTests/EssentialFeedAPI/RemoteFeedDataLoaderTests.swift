//
//  RemoteFeedDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2025-09-01.
//

import XCTest
import EssentialFeed

class RemoteFeedDataLoader {
    init(client: Any) {
        
    }
}
final class RemoteFeedDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty, "Expected empty url upon initializing")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteFeedDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedDataLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return(sut, client)
    }
    
    // MARK: - HTTPClientSpy
    private class HTTPClientSpy {
        var requestedURLs = [URL]()
    }
}

