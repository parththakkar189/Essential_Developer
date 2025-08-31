//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//

// MARK: - FeedImageViewModel

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        location != nil
    }
}
