//
//  CoreDataFeedStore+FeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-16.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result{
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping ErrorCompletionHandler) {
        perform { context in
            completion(Result{
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timeStamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                try context.save()
            })
        }
    }
    
    public func deleteCachedFeed(completion: @escaping ErrorCompletionHandler) {
        perform { context in
            completion(Result{
                try ManagedCache.find(in: context)
                    .map(context.delete)
                    .map(context.save)
            })
        }
    }
    
}
