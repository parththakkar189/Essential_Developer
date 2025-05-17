//
//  CodableFeedStoreTests.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-05-17.
//

import XCTest

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setUpEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrive: .empty)
    }
    
    func test_retrive_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetriveTwice: .empty)
    }
    
    
    func test_retrive_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        
        insert(cache: (feed, timeStamp), to: sut)
        
        expect(sut, toRetrive: .found(feed: feed, timestamp: timeStamp))
    }
    
    func test_retriveHasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        
        insert(cache: (feed, timeStamp), to: sut)
        
        expect(sut, toRetriveTwice: .found(feed: feed, timestamp: timeStamp))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecifiStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrive: .failure(anyError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecifiStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetriveTwice: .failure(anyError()))
    }
    
    func test_insert_overridesPerviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert(cache: (uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        let latestInsertionError = insert(cache: (latestFeed, latestTimestamp), to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to insert cache successfully")
        
        expect(sut, toRetrive: .found(feed: latestFeed, timestamp: latestTimestamp))
        
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-URL")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert(cache: (feed, timestamp), to: sut)
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        
        expect(sut, toRetrive: .empty)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert(cache: (uniqueImageFeed().local, timeStamp: Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        
        expect(sut, toRetrive: .empty)
    }
    
    func test_delete_deliversErrorOnDeletionErrro() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        
        expect(sut, toRetrive: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        let op1 = expectation(description: "Wait for Op1 to finish")
        
        sut.insert(uniqueImageFeed().local, timeStamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Wait for Op2 to finish")
        
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
            
        let op3 = expectation(description: "Wait for Op3 to finish")
        
        sut.insert(uniqueImageFeed().local, timeStamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in wrong order")
    }
    // MARK: - Helpers
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> FeedStore {
        let storeURL = storeURL ?? testSpecifiStoreURL()
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: FeedStore,
        toRetrive expectedResult: RetrieveCachedFeedResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
            case let(.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    @discardableResult
    private func insert(cache: (feed: [LocalFeedImage], timeStamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache retrieval")
        var insertionError: Error?
        sut.insert(cache.feed, timeStamp: cache.timeStamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        
        wait(for:[exp], timeout: 5.0)
        return insertionError
    }
    
    @discardableResult
    private func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        return deletionError
    }
    
    private func expect(
        _ sut: FeedStore,
        toRetriveTwice expectedResult: RetrieveCachedFeedResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrive: expectedResult)
        expect(sut, toRetrive: expectedResult)
    }
    
    private func testSpecifiStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
        
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setUpEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecifiStoreURL())
    }
}
