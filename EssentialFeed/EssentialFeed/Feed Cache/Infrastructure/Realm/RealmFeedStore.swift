//
//  RealmFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 20/09/25.
//

import RealmSwift
import Foundation

public final class RealmFeedStore: FeedStore {
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    let queue = DispatchQueue(label: "Run realm operations", qos: .userInteractive, attributes: .concurrent)
    
    public func retrieve(completion: @escaping retrieveErrorCompletion) {
        queue.async() { [weak self] in
            guard let self = self else { return }
            do {
                let realm = try Realm(configuration: Realm.Configuration(fileURL: self.storeURL, deleteRealmIfMigrationNeeded: true))
                
                if let cache = realm.objects(PersistedCache.self).first {
                    let localFeed = cache.localFeed
                    completion(.found(Array(localFeed), cache.timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            do {
                let realm = try Realm(configuration: Realm.Configuration(fileURL: self.storeURL, deleteRealmIfMigrationNeeded: true))
                
                try realm.write {
                    realm.delete(realm.objects(PersistedCache.self))
                    realm.add(PersistedCache.convert(from: items, timestamp: timestamp))
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCachedFeed(completion: @escaping deletionErrorCompletion) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            do {
                let realm = try Realm(configuration: Realm.Configuration(fileURL: self.storeURL, deleteRealmIfMigrationNeeded: true))
                try realm.write {
                    realm.delete(realm.objects(PersistedCache.self))
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
