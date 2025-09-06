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
    
    func deleteCachedFeed(completion: @escaping deletionErrorCompletion)
    func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion)
    func retrieve(completion: @escaping retrieveErrorCompletion)
}
