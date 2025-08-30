//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//

// MARK: - FeedPresenter

public final class FeedPresenter {
    private let view: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    public static var title: String {
        Localized.Feed.title
    }
    public init(
        view: FeedView,
        loadingView: FeedLoadingView,
        errorView: FeedErrorView
    ) {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.init(errorMessage: .none))
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        view.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(errorMessage: Localized.Feed.loadError))
    }
}
