//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2024-12-14.
//


import Foundation
    
public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    
    typealias OperationResult = Swift.Result<Void, Error>
    typealias ErrorCompletionHandler = (OperationResult) -> Void
    
    typealias RetrievalResult = Swift.Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    
    func deleteCachedFeed(completion: @escaping ErrorCompletionHandler)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    
    func insert(_ feed: [LocalFeedImage ], timeStamp: Date, completion: @escaping ErrorCompletionHandler)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    
    func retrieve(completion: @escaping RetrievalCompletion)
}
