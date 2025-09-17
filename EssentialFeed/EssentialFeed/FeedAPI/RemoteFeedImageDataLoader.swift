//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-06.
//

import Foundation

public final class RemoteFeedImageDataLoader: FeedImageDataLoader {
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap({ (data, response) in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
            )
        }
        return task
    }
    
    // MARK: - HTTPTaskWrapper
    private final class HTTPTaskWrapper: FeedImageDataLoaderTask {
        private var completeion: ((FeedImageDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(
            _ completeion: @escaping (FeedImageDataLoader.Result) -> Void
        ) {
            self.completeion = completeion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completeion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        func preventFurtherCompletions() {
            completeion = nil
        }
    }
}
