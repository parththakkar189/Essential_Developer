//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    
    private init() {}
    
    fileprivate static func adaptFeedToCellControllers(forwardingTo feedController: FeedViewController, imageLoader: any FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak feedController] feed  in
            feedController?.tableModel = feed.map(
                { model in
                    FeedImageCellController(
                        viewModel: FeedImageViewModel(
                            model: model,
                            imageLoader: imageLoader,
                            imageTransformer: UIImage.init
                        )
                    )
            })
        }
    }
    
    public static func feedComposedWith(
        feedLoader: FeedLoader,
        imageLoader: FeedImageDataLoader
    ) -> FeedViewController {
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, imageLoader: imageLoader)
        return feedController
    }
}
