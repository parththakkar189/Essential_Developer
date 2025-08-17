//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import UIKit

// MARK: FeedRefreshViewController

public final class FeedRefreshViewController: NSObject {
    public lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }

    fileprivate func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
}


