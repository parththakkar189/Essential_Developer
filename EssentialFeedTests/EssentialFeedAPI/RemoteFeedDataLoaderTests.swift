//
//  RemoteFeedDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2025-09-01.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    func loadImageData(url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return HTTPTaskWrapper(
            wrapped: client.get(from: url) { [weak self] result in
                guard self != nil else { return }
                switch result {
                case let .success((data, response)):
                    guard response.statusCode == 200, !data.isEmpty else {
                        return completion(.failure(Error.invalidData))
                    }
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    // MARK: - HTTPTaskWrapper
    private struct HTTPTaskWrapper: FeedImageDataLoaderTask {
        let wrapped: HTTPClientTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
}
final class RemoteFeedDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty, "Expected empty url upon initializing")
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = anyURL()
        let (sut, client) = makeSUT()
        
        sut.loadImageData(url: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT()
        
        sut.loadImageData(url: url) { _ in }
        sut.loadImageData(url: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_loadImageDataFromURL_deliversErrorOnClientError() {
        let clientError = anyError()
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(clientError), when: {
            client.complete(with: clientError)
        })
    }
    
    func test_loadImageDataFromURL_DeliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(RemoteFeedImageDataLoader.Error.invalidData), when: {
                client.complete(withstatusCode: code, data: anyData(), at: index)
            })
        }
    }
    
    func test_loadImageDataFromURL_DeliversInvalidDataErrorOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let emptyData = Data()
        
        expect(sut, toCompleteWith: .failure(RemoteFeedImageDataLoader.Error.invalidData), when: {
            client.complete(withstatusCode: 200, data: emptyData)
        })
    }
    
    func test_loadImageDataFromURL_DeliversEmptyDataOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let nonEmptyData = anyData()
        
        expect(sut, toCompleteWith: .success(nonEmptyData), when: {
            client.complete(withstatusCode: 200, data: nonEmptyData)
        })
    }
    
    func test_loadImageDataFromURL_DoesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteFeedImageDataLoader? = RemoteFeedImageDataLoader(client: client)
        
        var capturedResults = [FeedImageDataLoader.Result]()
        sut?.loadImageData(url: anyURL()) { capturedResults.append($0) }
        
        sut = nil
        client.complete(withstatusCode: 200, data: anyData())
        
        XCTAssertTrue(capturedResults.isEmpty)
        
    }
    
    func test_cancelLoadImageDataURLTask_cancelsClientURLRequest() {
        let (sut, client) = makeSUT()
        
        let url = anyURL()
        
        let task = sut.loadImageData(url: url) { _ in }
        
        XCTAssertTrue(client.cancelledURls.isEmpty, "Expected no cancelled URL request until task is cancelled.")
        
        task.cancel()
        XCTAssertEqual(client.cancelledURls, [url], "Expected cancelled URL request after task is cancelled.")
    }

    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return(sut, client)
    }
    
    private func anyData() -> Data {
        Data("any Data".utf8)
    }
    
    
    private func failure(_ error: RemoteFeedImageDataLoader.Error) -> FeedImageDataLoader.Result {
        .failure(error)
    }
    private func expect(
        _ sut: RemoteFeedImageDataLoader,
        toCompleteWith expectedResult: FeedImageDataLoader.Result,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let url = anyURL()
        let exp = expectation(description: "Wait for load completion")
        
        sut.loadImageData(url: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (
                .success(receivedData),
                .success(expectedData)
            ):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            case let (
                .failure(receivedError  as RemoteFeedImageDataLoader.Error),
                .failure(expectedError as RemoteFeedImageDataLoader.Error)
            ):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            case let (
                .failure(receivedError  as NSError),
                .failure(expectedError as NSError)
            ):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - HTTPClientSpy
    private class HTTPClientSpy: HTTPClient {

        private var messages = [(url: URL, completion: (HTTPClientSpy.Result) ->Void)]()
        private(set) var cancelledURls = [URL]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask  {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURls.append(url)
            }
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withstatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
        
        // MARK: - TaskWrapper
        
        private struct Task: HTTPClientTask {
            
            let callback: () -> Void
            func cancel() { callback() }
        }
    }
}

