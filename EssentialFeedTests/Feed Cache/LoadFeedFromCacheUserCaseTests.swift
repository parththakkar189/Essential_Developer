//
//  LoadFeedFromCacheUserCaseTests.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2025-01-18.
//

import XCTest

final class LoadFeedFromCacheUserCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    // MARK: - Helper
    
    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file ,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
         typealias ErrorCompletionHandler = (Error?) -> Void
         
         enum ReceivedMessage: Equatable {
             case deleteCachedFeed
             case insert([LocalFeedImage], Date)
         }
         
         private(set) var receivedMessages = [ReceivedMessage]()
         
         private var deletionCompletions = [ErrorCompletionHandler]()
         private var insertionCompletions = [ErrorCompletionHandler]()
         
         func deleteCachedFeed(completion: @escaping ErrorCompletionHandler) {
             deletionCompletions.append(completion)
             receivedMessages.append(.deleteCachedFeed)
         }
         
         func completeDeletion(with error: Error, at index: Int = 0) {
             deletionCompletions[index](error)
         }
         
         func completeDeletionSuccessfully(at index: Int = 0) {
             deletionCompletions[index](nil)
         }
         
         func insert(_ feed: [LocalFeedImage], timeStamp: Date, completion: @escaping ErrorCompletionHandler) {
             insertionCompletions.append(completion)
             receivedMessages.append(.insert(feed, timeStamp))
         }
         
         func completeInsertion(with error: Error, at index: Int = 0) {
             insertionCompletions[index](error)
         }
         
         func completeInsertionSuccessfully(at index: Int = 0) {
             insertionCompletions[index](nil)
         }
     }
}
