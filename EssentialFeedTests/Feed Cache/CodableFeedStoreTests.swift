//
//  CodableFeedStoreTests.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-05-17.
//

import XCTest

class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timeStamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    init(storeURL: URL) {
        self.storeURL  = storeURL
    }
    
    // MARK: - Private
    
    // MARK: - Properties
    
    private let storeURL: URL
    
    // MARK: - Internal
    
    // MARK: - Methods
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        let decode = JSONDecoder()
        let cache = try! decode.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timeStamp))
    }
    
    func insert(_ feed: [LocalFeedImage ], timeStamp: Date, completion: @escaping FeedStore.ErrorCompletionHandler) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timeStamp: timeStamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

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
    
    func test_retriveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
       
        let exp = expectation(description: "Wait for cache retrieval")
        sut.insert(feed, timeStamp: timeStamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            exp.fulfill()
        }
        
        wait(for:[exp], timeout: 1.0)
        
        expect(sut, toRetrive: .found(feed: feed, timestamp: timeStamp))
    }
    
    func test_retriveHasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timeStamp = Date()
        let exp = expectation(description: "Wait for cache retrieval")
        sut.insert(feed, timeStamp: timeStamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            sut.retrieve { firstRetrieveResult in
                sut.retrieve { secondRetrieveResult in
                    switch (firstRetrieveResult, secondRetrieveResult) {
                    case (.found(let firstFound), .found(let secondFound)):
                        XCTAssertEqual(firstFound.feed, feed)
                        XCTAssertEqual(firstFound.timestamp, timeStamp)
                        XCTAssertEqual(secondFound.feed, feed)
                        XCTAssertEqual(secondFound.timestamp, timeStamp)
                    default:
                        XCTFail("Expected retrieving twice from non empty cache to deliver same found result with feed \(feed) and timeStamp \(timeStamp), got \(firstRetrieveResult) and \(secondRetrieveResult) instead")
                    }
                    exp.fulfill()
                }
            }
        }
        
        wait(for:[exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> CodableFeedStore {
        let storeURL = tetsSpecifiStoreURL()
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: CodableFeedStore,
        toRetrive expectedResult: RetrieveCachedFeedResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
                break
            case let(.found(expected), .found(retrieved)):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(
        _ sut: CodableFeedStore,
        toRetriveTwice expectedResult: RetrieveCachedFeedResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrive: expectedResult)
        expect(sut, toRetrive: expectedResult)
    }
    
    private func tetsSpecifiStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func setUpEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: tetsSpecifiStoreURL())
    }
}
