//
//  HTTPClientSpy.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-06.
//

import Foundation
import EssentialFeed

// MARK: - HTTPClientSpy
class HTTPClientSpy: HTTPClient {
    
    private var messages = [(url: URL, completion: (HTTPClientSpy.Result) ->Void)]()
    private(set) var cancelledURls = [URL]()
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask  {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURls.append(url)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
    
    // MARK: - TaskWrapper
    
    private struct Task: HTTPClientTask {
        
        let callback: () -> Void
        func cancel() { callback() }
    }
}
