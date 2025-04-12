//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2024-12-14.
//


import Foundation

public protocol FeedStore {
    typealias ErrorCompletionHandler = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping ErrorCompletionHandler)
    func insert(_ feed: [LocalFeedImage ], timeStamp: Date, completion: @escaping ErrorCompletionHandler)
    func retrieve(completion: @escaping ErrorCompletionHandler)
}


