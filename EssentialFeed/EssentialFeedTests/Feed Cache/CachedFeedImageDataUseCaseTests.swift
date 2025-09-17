//
//  CachedFeedImageDataUseCaseTests.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-07.
//

import XCTest
import EssentialFeed

// MARK: - CachedFeedImageDataUseCaseTests

final class CachedFeedImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    func test_saveImageForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data: data, for: url, completion: { _ in })
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageForURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWith: failed()) {
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_saveImageDataForURL_succeedOnSuccessfulStoreInsertion() {
        let(sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(())) {
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_saveImageDataForURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedImageDataStoreSpy()
        var sut: LocalFeedImageDataLoader? = LocalFeedImageDataLoader(store: store)
        
        let foundData = anyData()
        let url = anyURL()
        
        var receivedMessages = [LocalFeedImageDataLoader.SaveResult]()
        sut?.save(data: foundData, for: url) { result in
            receivedMessages.append(result)
        }
        
        sut = nil
        store.completeInsertionSuccessfully()
        
        XCTAssertTrue(receivedMessages.isEmpty, "Expected no received results after sut instance has been deallocated.")
    }
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalFeedImageDataLoader,
        toCompleteWith expectedResult: LocalFeedImageDataLoader.SaveResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.save(
            data: anyData(),
            for: anyURL(),
            completion: { receivedResult in
                switch (receivedResult, expectedResult) {
                case(.success, .success):
                    break
                case let (.failure(receivedError as LocalFeedImageDataLoader.SaveError), .failure(expectedError as LocalFeedImageDataLoader.SaveError)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail(
                        "Expected result \(expectedResult), got \(receivedResult) instead",
                        file: file,
                        line: line
                    )
                }
                exp.fulfill()
            })
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failed() -> LocalFeedImageDataLoader.SaveResult {
        return .failure(LocalFeedImageDataLoader.SaveError.failed)
    }
}
