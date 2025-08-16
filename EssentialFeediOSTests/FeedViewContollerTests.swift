//
//  FeedViewContollerTests.swift
//  EssentialFeediOSTests
//
//  Created by Parth Thakkar on 2025-07-26.
//

import XCTest
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewContollerTests: XCTestCase {

    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut , loader) = makeSUT()
        
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.simulateAppearance()
        
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateAppearance()
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateAppearance()
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third load request once user initiates another load")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed successfully")
        
        sut.simulateAppearance()
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed with failure")
    }
    
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let imageZero = makeImage(description: "an Image", location: "a location")
        let imageOne = makeImage(description: nil, location: "a location")
        let imageTwo = makeImage(description: "an Image", location: nil)
        let imageThree = makeImage(description: nil, location: nil)
        
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [imageZero], at: 0)
        assertThat(sut, isRendering: [imageZero])
        
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [imageZero, imageOne, imageTwo, imageThree], at: 1)
        
        assertThat(sut, isRendering: [imageZero, imageOne, imageTwo, imageThree])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderStateOnError() {
        let imageZero = makeImage(description: "an Image", location: "a location")
        
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
    
        loader.completeFeedLoading(with: [imageZero], at: 0)
        assertThat(sut, isRendering: [imageZero])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering:[imageZero])
    }
    
    func test_feedImageView_loadsImageURLWhenVisibile() {
        let imageZero = makeImage(url: URL(string: "http://url-0.com")!)
        let imageOne = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeFeedLoading(with: [imageZero, imageOne])
        
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url], "Expected image URL request for the first visible image")
        
        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url], "Expected image URL request for the first visible image")
    }
    
    func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnyMore() {
        let imageZero = makeImage(url: URL(string: "http://url-0.com")!)
        let imageOne = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeFeedLoading(with: [imageZero, imageOne])
        
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url], "Expected once cancelled image URL request for the first image is not visible anymore")
        
        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url], "Expected two cancelled image URL request for the one second image is also not visible anymore")
    }
    
    func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let imageZero = makeImage(url: URL(string: "http://url-0.com")!)
        let imageOne = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeFeedLoading(with: [imageZero, imageOne])
        
        let view0 = sut.simulateFeedImageViewVisible(at: 0)
        let view1 = sut.simulateFeedImageViewVisible(at: 1)
        
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first image once loading is completed successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second image")
        
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first image once loading is completed successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second image once loading is completed with error")
    }
    
    func test_feedImageView_rendersImageLoadedFromURL() {
        let imageZero = makeImage(url: URL(string: "http://url-0.com")!)
        let imageOne = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeFeedLoading(with: [imageZero, imageOne])
        
        let viewZero = sut.simulateFeedImageViewVisible(at: 0)
        let viewOne = sut.simulateFeedImageViewVisible(at: 1)
        
        XCTAssertEqual(viewZero?.renderedImage, .none, "Expected no image for the first view while loading first image")
        XCTAssertEqual(viewOne?.renderedImage, .none, "Exptected no image for second view while loading second image")
        
        let imageDataZero = UIImage.make(withColor: .red).pngData()!
        
        loader.completeImageLoading(with: imageDataZero, at: 0)
        XCTAssertEqual(viewZero?.renderedImage, imageDataZero, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(viewOne?.renderedImage, .none, "Exptected no image state change for second view once first image loading compltes successfully")
        
        let imageDataOne = UIImage.make(withColor: .blue).pngData()!
        
        loader.completeImageLoading(with: imageDataOne, at: 1)

        XCTAssertEqual(viewZero?.renderedImage, imageDataZero, "Expected no image change for first view once second image loading completes successfully")
        XCTAssertEqual(viewOne?.renderedImage, imageDataOne, "Expected image for second view once second image loading completes successfully")
    }
    
    func test_feedImageViewRetryButton_isVisibileOnImageURLLoadError() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeFeedLoading(with: [makeImage(), makeImage()])
        
        let viewZero = sut.simulateFeedImageViewVisible(at: 0)
        let viewOne = sut.simulateFeedImageViewVisible(at: 1)
        
        XCTAssertEqual(viewZero?.isShowingRetryAction, false, "Expected no retry button for first view while loading first image")
        XCTAssertEqual(viewOne?.isShowingRetryAction, false, "Expected no retry button for second view while loading second image")
        
        let imageDataZero = UIImage.make(withColor: .red).pngData()!
        
        loader.completeImageLoading(with: imageDataZero, at: 0)
        XCTAssertEqual(viewZero?.isShowingRetryAction, false, "Expected no retry button for first view once first image loading completes successfully")
        XCTAssertEqual(viewOne?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")
        

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(viewZero?.isShowingRetryAction, false, "Expected no retry button for first view once second image loading completes successfully")
        XCTAssertEqual(viewOne?.isShowingRetryAction, true, "Expected retry button for second view once second image loading completes with error")
        
    }
    
    func test_feedImageViewRetryButton_isVisibleOnInvalidImageData() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        loader.completeFeedLoading(with: [makeImage()])
        
        let view = sut.simulateFeedImageViewVisible(at: 0)
        
        XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry button for first view while loading first image")
        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        
        XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry button for first view once first image loading completes with invalid image data")
    }
    
    func test_feedImageViewRetryAction_retriesImageLoad() {
        let imageZero = makeImage(url: URL(string: "http://url-0.com")!)
        let imageOne = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeFeedLoading(with: [imageZero, imageOne])
        
        let viewZero = sut.simulateFeedImageViewVisible(at: 0)
        let viewOne = sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url], "Expected two image URL requests for the two visible views")
        
        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url], "Expected no new image URL requests until retry actions are initiated")

        viewZero?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url, imageZero.url], "Expected third image URL request for first view once its retry action is initiated")
        
        viewOne?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url, imageZero.url, imageOne.url], "Expected fourth image URL request for first view once its retry action is initiated")
    }
    
    func test_feedImageView_preloadsImageURLWhenNearVisible() {
        let imageZero = makeImage(url: URL(string: "http://url-0.com")!)
        let imageOne = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeFeedLoading(with: [imageZero, imageOne])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is nearly visible")
        
        sut.simulateFeedImageViewNearVisibile(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url], "Expecated first image URL request once first image is near visible")
        
        sut.simulateFeedImageViewNearVisibile(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [imageZero.url, imageOne.url], "Expecated second image URL request once second image is near visible")
    }
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(
            feedLoader: loader,
            imageLoader: loader
        )
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeImage(
        description: String? = nil,
        location: String? = nil,
        url: URL = URL(string: "http://any-url.com")!
    ) -> FeedImage {
        return FeedImage(
            id: UUID(),
            description: description,
            location: location,
            url: URL(string: "https://example.com/image.jpg")!
        )
    }
    
    private func assertThat(
        _ sut: FeedViewController,
        isRendering feed: [FeedImage],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: FeedViewController,
        hasViewConfiguredFor image: FeedImage,
        at row: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.feedImageView(at: row)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance at row \(row), got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = image.location != nil
        
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected location to be \(shouldLocationBeVisible ? "visible" : "hidden") at row \(row)", file: file, line: line)
        XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(image.description ?? "nil") at row \(row)", file: file, line: line)
        XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(image.location ?? "nil") at row \(row)", file: file, line: line)
    }
    // MARK: - LoaderSpy
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        // MARK: - FeedLoader
        private var feedRequests = [(FeedLoader.Result) -> Void]()
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            feedRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(
            from url: URL,
            completion: @escaping (FeedImageDataLoader.Result) -> Void
        ) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [self] in
                cancelledImageURLs.append(url)
            }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                    (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing: Bool = false
    
    override var isRefreshing: Bool {
        return _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

private extension FeedViewController {
    
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

// MARK: - FeedImageCell + Extension

extension FeedImageCell {
    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }
    
    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }
    
    var locationText: String? {
        return locationLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
    
    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }
    
    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}

private extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                    (target as NSObject).perform(Selector($0))
            }
        }
    }
}
