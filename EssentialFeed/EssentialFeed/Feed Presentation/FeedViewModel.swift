//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//


// MARK: - FeedView

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

// MARK: - FeedViewModel

public struct FeedViewModel {
    public let feed: [FeedImage]
}
