//
//  FeedViewController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-05.
//

import UIKit
import EssentialFeed

// MARK: - FeedViewControllerDelegate

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

// MARK: FeedViewController

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView {
    
    @IBOutlet private(set) public var errorView: ErrorView!
    
    var delegate: FeedViewControllerDelegate?
    var onViewIsAppearing: ((FeedViewController) -> Void)?
    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        onViewIsAppearing = { feedViewController in
            feedViewController.onViewIsAppearing = nil
            feedViewController.refresh()
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Tableview Delegate & DataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    
    // MARK: - Helper
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

extension FeedViewController: FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel) {
        if let errorMessage = viewModel.errorMessage {
            errorView.show(message: errorMessage)
        } else {
            errorView.hideMessage()
        }
    }
}
