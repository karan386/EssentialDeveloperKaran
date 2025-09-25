//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Karan Sawant on 04/09/25.
//

import XCTest
import EssentialFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    
    var deletionCompletions: [deletionErrorCompletion] = []
    var insertionCompletions: [insertionErrorCompletion] = []
    var retrieveCompletions: [retrieveErrorCompletion] = []
    
    
    func deleteCachedFeed(completion: @escaping deletionErrorCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion) {
        receivedMessages.append(.insert(feed, timestamp))
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
    
    func retrieve(completion: @escaping retrieveErrorCompletion) {
        receivedMessages.append(.retrieve)
        retrieveCompletions.append(completion)
    }
    
    func retrieveCache(with error: Error, at index: Int = 0) {
        retrieveCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrieveCompletions[index](.success(.none))
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date , at index: Int = 0) {
        retrieveCompletions[index](.success(.some((feed, timestamp))))
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retrieveCompletions[index](.failure(error))
    }
}
