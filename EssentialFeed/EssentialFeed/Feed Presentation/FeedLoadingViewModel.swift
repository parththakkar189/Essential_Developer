//
//  FeedLoadingViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//

// MARK: - FeedLoadingView

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

// MARK: - FeedLoadingViewModel

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}
