//
//  FeedRefreshViewController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import UIKit

// MARK: - FeedRefreshViewControllerDelegate

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

// MARK: FeedRefreshViewController

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    @IBOutlet public var view: UIRefreshControl?
    
    var delegate: FeedRefreshViewControllerDelegate?

    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
 
    }
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
}


