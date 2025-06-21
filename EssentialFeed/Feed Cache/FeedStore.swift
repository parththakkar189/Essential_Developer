//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2024-12-14.
//


import Foundation
    
public enum CachedFeed {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
}
public protocol FeedStore {
    
    typealias Result = Swift.Result<CachedFeed, Error>
    typealias ErrorCompletionHandler = (Error?) -> Void
    typealias RetrievalCompletion = (Result) -> Void
    
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


