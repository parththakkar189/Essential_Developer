//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-30.
//

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public struct FeedErrorViewModel {
    public let errorMessage: String?
    
    static var noError: FeedErrorViewModel? {
        return FeedErrorViewModel(errorMessage: nil)
    }
    
    static func error(errorMessage: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(errorMessage: errorMessage)
    }
}

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
