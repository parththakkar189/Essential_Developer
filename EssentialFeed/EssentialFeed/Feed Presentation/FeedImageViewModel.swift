//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//

// MARK: - FeedImageViewModel

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        location != nil
    }
}
