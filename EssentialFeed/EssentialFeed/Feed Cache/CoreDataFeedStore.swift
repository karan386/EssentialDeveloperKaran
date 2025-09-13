//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 13/09/25.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    public init() {}
    
    private class ManagedCache: NSManagedObject {
        @NSManaged var timestamp: Date
        @NSManaged var feed: NSOrderedSet
    }
    
    private class ManagedFeedImage: NSManagedObject {
        @NSManaged var id: UUID
        @NSManaged var imageDescription: String?
        @NSManaged var location: String?
        @NSManaged var url: URL
        @NSManaged var cache: ManagedCache
    }
    
    public func deleteCachedFeed(completion: @escaping deletionErrorCompletion) {
        
    }
    
    public func insert(_ items: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion) {
        
    }
    
    
    public func retrieve(completion: @escaping retrieveErrorCompletion) {
        completion(.empty)
    }
}
