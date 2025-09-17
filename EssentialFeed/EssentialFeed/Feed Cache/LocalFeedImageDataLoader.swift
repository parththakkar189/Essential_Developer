//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-06.
//

import Foundation

// MARK: - LocalFeedImageDataLoader

public final class LocalFeedImageDataLoader {
    
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}
extension LocalFeedImageDataLoader {
    public typealias SaveResult = Result<Void, Error>
    
    public enum SaveError: Error {
        case failed
    }
    public func save(
        data: Data,
        for url: URL,
        completion: @escaping (SaveResult) -> Void
    ) {
        store.insert(
            data,
            for: url,
            completion: { [weak self] result in
                guard self != nil else { return }
                
                completion(result.mapError { _ in SaveError.failed })
            })
    }
}
extension LocalFeedImageDataLoader: FeedImageDataLoader {
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> any FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                .mapError{ _ in LoadError.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(LoadError.notFound)
                }
            )
        }
        return task
    }
    
    // MARK:- TaskWrapper
    
    private final class LoadImageDataTask: FeedImageDataLoaderTask {
        private var completons: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completon: ((FeedImageDataLoader.Result) -> Void)? = nil) {
            self.completons = completon
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completons?(result)
        }
        
        func preventFurtherCompletions() {
            completons = nil
        }
        func cancel() {
            preventFurtherCompletions()
        }
    }
    
}
