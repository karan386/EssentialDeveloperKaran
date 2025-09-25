//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 13/09/25.
//

import XCTest
import EssentialFeed

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
