//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-02.
//

import Foundation


public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
