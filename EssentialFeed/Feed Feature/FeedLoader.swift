//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-02.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
