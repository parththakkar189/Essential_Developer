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
    func insert(_ items: [LocalFeedItem], timeStamp: Date, completion: @escaping ErrorCompletionHandler)
}

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String? = nil , imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
