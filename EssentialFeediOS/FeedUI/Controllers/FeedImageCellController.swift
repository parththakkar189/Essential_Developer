//
//  FeedImageCelController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import UIKit

protocol FeedImageCellCotrollerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
    
    private let delegate: FeedImageCellCotrollerDelegate
    private lazy var cell = FeedImageCell()
    
    init(
        delegate: FeedImageCellCotrollerDelegate
    ) {
        self.delegate = delegate
    }
    
    func view() -> UITableViewCell {
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        delegate.didCancelImageRequest()
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = viewModel.image
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell.onRetry = delegate.didRequestImage
    }
}
