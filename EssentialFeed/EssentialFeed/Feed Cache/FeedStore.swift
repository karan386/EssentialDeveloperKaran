//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 31/08/25.
//

import Foundation

public enum RetrieveCacheFeedResult {
    case empty
    case found([LocalFeedImage], Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias deletionErrorCompletion = (Error?) -> Void
    typealias insertionErrorCompletion = (Error?) -> Void
    typealias retrieveErrorCompletion = (RetrieveCacheFeedResult) -> Void
    
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
