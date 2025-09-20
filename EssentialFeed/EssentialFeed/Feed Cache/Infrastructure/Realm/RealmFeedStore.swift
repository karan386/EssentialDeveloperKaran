//
//  RealmFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 20/09/25.
//

import RealmSwift

public final class RealmFeedStore {
    
    public init() {}
    
    public func retrieve(completion: @escaping FeedStore.retrieveErrorCompletion) {
        completion(.empty)
    }
}
