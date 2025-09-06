//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 31/08/25.
//

import Foundation

public protocol FeedStore {
    typealias deletionErrorCompletion = (Error?) -> Void
    typealias insertionErrorCompletion = (Error?) -> Void
    typealias retrieveErrorCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping deletionErrorCompletion)
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping insertionErrorCompletion)
    func retrieve(completion: @escaping retrieveErrorCompletion)
}
