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

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

struct FeedErrorViewModel {
    let errorMessage: String?
}

// MARK: FeedViewModel

final class FeedPresenter {
    private let view: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView

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
        loadingView: FeedLoadingView,
        errorView: FeedErrorView
    ) {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    func didStartLoadingFeed() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didStartLoadingFeed()
            }
        }
        errorView.display(.init(errorMessage: .none))
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
        errorView.display(.init(errorMessage: Localized.Feed.loadError))
    }
}
