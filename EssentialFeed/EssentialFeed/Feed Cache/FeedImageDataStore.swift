//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-06.
//

import Foundation

// MARK: - FeedImageDataStore

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertResult = Swift.Result<Void, Error>

    func insert(
        _ data: Data,
        for url: URL,
        completion: @escaping(InsertResult) -> Void
    )
    
    func retrieve(
        dataForURL url: URL,
        completion: @escaping (RetrievalResult) -> Void
    )
}
