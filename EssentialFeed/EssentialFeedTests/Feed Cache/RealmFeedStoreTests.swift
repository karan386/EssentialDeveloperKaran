//
//  RealmFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Karan Sawant on 20/09/25.
//

import XCTest
import EssentialFeed

private final class RealmFeedStore {
    func retrieve(completion: @escaping FeedStore.retrieveErrorCompletion) {
        completion(.empty)
    }
}

final class RealmFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(from: sut, expectedResult: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(from: sut, expectedResult: .empty)
        expect(from: sut, expectedResult: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        
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
    
    // MARK: Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> RealmFeedStore {
        let sut = RealmFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(from sut: RealmFeedStore, expectedResult: RetrieveCacheFeedResult , file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for retrieve to execute")
        
        sut.retrieve { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.empty, .empty):
                break
            default:
                XCTFail("Found value instead of empty")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
