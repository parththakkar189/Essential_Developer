//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2023-12-02.
//

import XCTest
class RemoteFeedLoader {}
class HTTPClient {
    var requestedURL: URL?
}
final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
