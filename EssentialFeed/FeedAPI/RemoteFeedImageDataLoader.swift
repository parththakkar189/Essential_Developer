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
        case invalidData
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                guard response.statusCode == 200, !data.isEmpty else {
                    return task.complete(with: .failure(Error.invalidData))
                }
                task.complete(with: .success(data))
            case let .failure(error):
                task.complete(with: .failure(error))
            }
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
