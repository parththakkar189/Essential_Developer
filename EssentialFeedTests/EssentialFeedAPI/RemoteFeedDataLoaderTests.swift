//
//  RemoteFeedDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2025-09-01.
//

import XCTest
import EssentialFeed

class RemoteFeedDataLoader {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(url: URL, completion: @escaping (Any) -> Void) {
        client.get(from: url) { _ in }
    }
}
final class RemoteFeedDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty, "Expected empty url upon initializing")
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT()
        
        sut.loadImageData(url: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
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
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
        }
    }
}

