//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 13/09/25.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping deletionErrorCompletion) {
        perform { context in
            do {
                try ManagedCache.find(context: context).map(context.delete)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func insert(_ items: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion) {
        perform { context in
            do {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: items, in: context)
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    public func retrieve(completion: @escaping retrieveErrorCompletion) {
        perform({ context in
            do {
                if let cache = try ManagedCache.find(context: context) {
                    completion(.success(.found(
                        cache.localFeed,
                        cache.timestamp)))
                } else {
                    completion(.success(.empty))
                }
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
