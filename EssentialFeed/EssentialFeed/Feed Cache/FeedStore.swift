//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 31/08/25.
//

import Foundation

public enum CachedFeed {
    case empty
    case found([LocalFeedImage], Date)
}

public protocol FeedStore {
    typealias deletionErrorCompletion = (Error?) -> Void
    typealias insertionErrorCompletion = (Error?) -> Void
    typealias retrieveErrorCompletion = (RetrievalResult) -> Void
    typealias RetrievalResult = Result<CachedFeed, Error>
    
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
