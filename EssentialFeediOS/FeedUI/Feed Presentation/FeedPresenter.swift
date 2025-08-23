//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-17.
//

import EssentialFeed
import Foundation


struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

// MARK: FeedViewModel

final class FeedPresenter {
    private let view: FeedView
    private let loadingView: FeedLoadingView
    
    static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: Self.self),
            comment: "Title for the feed view"
        )
    }
    
    init(
        view: FeedView,
        loadingView: FeedLoadingView
    ) {
        self.view = view
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didStartLoadingFeed()
            }
        }
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didFinishLoadingFeed(with: feed)
            }
        }
        view.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didFinishLoadingFeed(with: error)
            }
        }
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
