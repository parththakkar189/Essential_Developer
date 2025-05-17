//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2024-12-14.
//


import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias ErrorCompletionHandler = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    
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


