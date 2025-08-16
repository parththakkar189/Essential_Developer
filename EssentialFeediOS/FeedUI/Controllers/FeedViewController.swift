//
//  FeedViewController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-05.
//

import UIKit
import EssentialFeed

// MARK: FeedViewController
final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    public var refreshController: FeedRefreshViewController?
    private var imageLoader: FeedImageDataLoader?
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    private var tableModel = [FeedImage]() {
        didSet { tableView.reloadData() }
    }

    private var cellControllers = [IndexPath: FeedImageCelController]()
    
    convenience public init(
        feedLoader: FeedLoader,
        imageLoader: FeedImageDataLoader
    ) {
        self.init()
        self.refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        refreshController?.onRefresh = { [weak self] feed  in
            self?.tableModel = feed
        }
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        refreshControl = refreshController?.view
        onViewIsAppearing = { feedViewController in
            feedViewController.refresh()
            feedViewController.onViewIsAppearing = nil
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    func refresh() {
        refreshController?.refresh()
    }
    
    // MARK: - Tableview Delegate & DataSource
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellControllers(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            removeCellControllers(forRowAt: indexPath)
        }
    }
    
    
    // MARK: - Helper
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCelController {
        let cellModel = tableModel[indexPath.row]
        let cellController = FeedImageCelController(model: cellModel, imageLoader: imageLoader!)
        cellControllers[indexPath] = cellController
        return cellController
    }
    
    private func removeCellControllers(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}
