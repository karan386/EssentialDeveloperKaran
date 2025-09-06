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

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
