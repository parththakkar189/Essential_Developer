//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import EssentialFeed
import UIKit

// MARK: FeedRefreshViewController

public final class FeedRefreshViewController: NSObject {
    private let feedLoader: FeedLoader
    public lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}


