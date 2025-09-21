//
//  RealmFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Karan Sawant on 20/09/25.
//

import XCTest
import EssentialFeed

final class RealmFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(from: sut, expectedResult: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(from: sut, retrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        let exp = expectation(description: "wait for insert to complete")
        
        sut.insert(feed.local, timestamp: timestamp) { receivedError in
            exp.fulfill()
        }
        
        expect(from: sut, expectedResult: .found(feed.local, timestamp))
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed()
        let timestamp = Date()
        let exp = expectation(description: "wait for insert to complete")
        
        sut.insert(feed.local, timestamp: timestamp) { receivedError in
            exp.fulfill()
        }
        
        expect(from: sut, retrieveTwice: .found(feed.local, timestamp))
                
        wait(for: [exp], timeout: 1.0)
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
        let identifier = testSpecificStoreURL()
        let sut = RealmFeedStore(storeURL: identifier)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        let filename = "RealmFeedStoreTests.store" // fixed safe name
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        return tempDir.appendingPathComponent(filename)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func expect(from sut: RealmFeedStore, expectedResult: RetrieveCacheFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for retrieve to execute")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty):
                break
            case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
                XCTAssertEqual(retrievedFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(from sut: RealmFeedStore, retrieveTwice expectedResult: RetrieveCacheFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(from: sut, expectedResult: expectedResult, file: file, line: line)
        expect(from: sut, expectedResult: expectedResult, file: file, line: line)
    }
}
