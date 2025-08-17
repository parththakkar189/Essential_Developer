//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-17.
//

import EssentialFeed
import Foundation

// MARK: FeedViewModel

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
