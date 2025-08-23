//
//  FeedImageViewModel 2.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-23.
//

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
