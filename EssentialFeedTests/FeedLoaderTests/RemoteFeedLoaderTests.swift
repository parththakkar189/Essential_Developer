//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2023-12-02.
//

import XCTest
class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}
class HTTPClient {
    static let shared = HTTPClient()
    private init() {}
    var requestedURL: URL?
}
final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_loadRequestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
