//
//  File.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import EssentialFeed
import EssentialFeediOS
import Foundation
import UIKit

// MARK: FeedViewController + Extension

extension FeedViewController {
    
    // MARK: Properties
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }

    private var feedImagesSection: Int {
        return 0
    }

    // MARL: Methods
    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            replaceRefreshControlWIthFakeForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func replaceRefreshControlWIthFakeForiOS17Support() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fake
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        feedImageView(at: index) as? FeedImageCell
    }
    
    func simulateFeedImageViewNearVisibile(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisibile(at row: Int) {
        simulateFeedImageViewNearVisibile(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func simulateFeedImageViewNotVisible(at row: Int) {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }
}
