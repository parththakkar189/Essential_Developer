//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-17.
//

import EssentialFeed
import Foundation


protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

// MARK: FeedViewModel

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader
    
    var view: FeedView?
    weak var loadingView: FeedLoadingView?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.view?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
