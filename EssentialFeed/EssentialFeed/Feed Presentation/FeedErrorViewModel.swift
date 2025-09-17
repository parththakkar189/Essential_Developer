//
//  FeedErrorView.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//

// MARK: - FeedErrorView

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

// MARK: - FeedErrorViewModel

public struct FeedErrorViewModel {
    public let errorMessage: String?
    
    static var noError: FeedErrorViewModel? {
        return FeedErrorViewModel(errorMessage: nil)
    }
    
    static func error(errorMessage: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(errorMessage: errorMessage)
    }
}
