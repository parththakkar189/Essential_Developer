//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import Foundation

// MARK: FeedImageDataLoaderTask

public protocol FeedImageDataLoaderTask {
    func cancel()
}

// MARK: FeedImageDataLoader

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
