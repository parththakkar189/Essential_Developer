//
//  FeedStoreSpecs.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-05-19.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrive_deliversEmptyOnEmptyCache() throws
    func test_retrive_hasNoSideEffectsOnEmptyCache() throws
    func test_retrive_deliversFoundValuesOnNonEmptyCache() throws
    func test_retrive_hasNoSideEffectsOnNonEmptyCache() throws
    
    func test_insert_deliversNoErrorOnEmptyCache() throws
    func test_insert_deliversNoErrorOnNonEmptyCache() throws
    func test_insert_overridesPerviouslyInsertedCacheValues() throws
    
    func test_delete_deliversNoErrorOnEmptyCache() throws
    func test_delete_hasNoSideEffectsOnEmptyCache() throws
    func test_delete_deliversNoErrorOnNonEmptyCache() throws
    func test_delete_emptiesPreviouslyInsertedCache() throws
    
    func test_storeSideEffects_runSerially() throws
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError() throws
    func test_retrieve_hasNoSideEffectsOnFailure() throws
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError() throws
    func test_insert_hasNoSideEffectsOnInsertionError() throws
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError() throws
    func test_delete_hasNoSideEffectsOnDeletionError() throws
}

/// Protocl Composition FailableFeedStore
typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
