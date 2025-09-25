//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 31/08/25.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    typealias deletionResult = Error?
    typealias deletionErrorCompletion = (deletionResult) -> Void
    
    typealias insertionResult = Error?
    typealias insertionErrorCompletion = (insertionResult) -> Void
    
    
    typealias retrieveErrorCompletion = (RetrievalResult) -> Void
    typealias RetrievalResult = Result<CachedFeed?, Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping deletionErrorCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping retrieveErrorCompletion)
}
