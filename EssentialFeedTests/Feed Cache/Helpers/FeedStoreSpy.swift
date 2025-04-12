//
//  FeedStoreSpy.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-01-18.
//


import Foundation

class FeedStoreSpy: FeedStore {
    typealias ErrorCompletionHandler = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [ErrorCompletionHandler]()
    private var insertionCompletions = [ErrorCompletionHandler]()
    private var retrievalCompletions = [ErrorCompletionHandler]()
    
    func deleteCachedFeed(completion: @escaping ErrorCompletionHandler) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping ErrorCompletionHandler) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(feed, timeStamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping ErrorCompletionHandler) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
}
