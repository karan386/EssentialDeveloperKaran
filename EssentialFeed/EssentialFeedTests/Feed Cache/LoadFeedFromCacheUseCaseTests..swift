//
//  LoadFeedFromCacheUseCaseTests..swift
//  EssentialFeedTests
//
//  Created by Karan Sawant on 04/09/25.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        let exp = expectation(description: "wait for ")
        
        var receivedError: Error?
        var expectedError = anyNSError()
        sut.load { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        store.retrieveCache(with: expectedError)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as? NSError, expectedError)
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedImages: [FeedItem]?
        sut.load { result in
            switch result {
            case let .success(images):
                receivedImages = images
            default:
                XCTFail("Expected success, got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrievalWithEmptyCache()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedImages, [])
    }
    
    // MARK: Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}

