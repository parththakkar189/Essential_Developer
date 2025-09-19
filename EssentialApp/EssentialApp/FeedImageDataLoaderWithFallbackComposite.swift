//
//  FeedLoaderWithFallbackComposite 2.swift
//  EssentialApp
//
//  Created by Parth Thakkar on 2025-09-18.
//

import EssentialFeed
import Foundation

public class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    
    private let primary: FeedImageDataLoader
    private let fallback: FeedImageDataLoader
    
    public init(
        primary: FeedImageDataLoader,
        fallback: FeedImageDataLoader
    ) {
        self.primary = primary
        self.fallback = fallback
    }
    
    // MARK: - TaskWrapper
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primary.loadImageData(from: url, completion: { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
            }
        })
        return task
    }
}
