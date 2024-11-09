//
//  URLSessionHTTPClientTests.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2024-11-09.
//
import XCTest

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    
    // MARK:- Helpers
    private class URLSessionSpy: URLSession, @unchecked Sendable {
        var receivedURLs = [URL]()
        private let queue = DispatchQueue(label: "URLSessionSpy.queue")
        
        override func dataTask(
            with url: URL,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            queue.sync {
                receivedURLs.append(url)
            }
            return FakeURLSessionDataTask()
        }
        
        func getReceivedURLs() -> [URL] {
            return queue.sync {
                return receivedURLs
            }
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask, @unchecked Sendable { }
}

