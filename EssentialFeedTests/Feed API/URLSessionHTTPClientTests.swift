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
        session.dataTask(with: url) { _, _, _ in }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    // MARK:- Helpers
    private class URLSessionSpy: URLSession, @unchecked Sendable {
        var receivedURLs = [URL]()
        private let queue = DispatchQueue(label: "URLSessionSpy.queue")
        private var stubs = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
        
        
        
        override func dataTask(
            with url: URL,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            queue.sync {
                receivedURLs.append(url)
            }
            return stubs[url] ?? FakeURLSessionDataTask()
        }
        
        func getReceivedURLs() -> [URL] {
            return queue.sync {
                return receivedURLs
            }
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
        override func resume() {}
        
    }
    private class URLSessionDataTaskSpy: URLSessionDataTask, @unchecked Sendable {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
}

