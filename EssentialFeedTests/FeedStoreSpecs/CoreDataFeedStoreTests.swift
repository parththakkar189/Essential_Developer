//
//  CoreDataFeedStoreTests.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-05-19.
//

import XCTest

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrive_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrive_deliversFoundValuesOnNonEmptyCache() {
            
    }
    
    func test_retrive_hasNoSideEffectsOnNonEmptyCache() {
            
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
            
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
            
    }
    
    func test_insert_overridesPerviouslyInsertedCacheValues() {
            
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
            
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
            
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
            
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
            
    }
    
    func test_storeSideEffects_runSerially() {
            
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let sut = try! CoreDataFeedStore(bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
