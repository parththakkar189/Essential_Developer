//
//  FeedImageCelController.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import EssentialFeed
import UIKit

final class FeedImageCelController {
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    init(
        model: FeedImage,
        imageLoader: FeedImageDataLoader
    ) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        
        cell.locationContainer.isHidden = (self.model.location == nil)
        cell.locationLabel.text = self.model.location
        cell.descriptionLabel.text = self.model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startAnimating()
        let loadImage = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            self.task = self.imageLoader.loadImageData(from: self.model.url) { [cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell.feedImageView.image = image
                cell.feedImageRetryButton.isHidden = (image != nil)
                cell.feedImageContainer.stopAnimating()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
    deinit {
        task?.cancel()
    }
}
