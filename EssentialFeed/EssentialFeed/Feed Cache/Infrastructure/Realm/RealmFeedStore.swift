//
//  RealmFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 20/09/25.
//

import RealmSwift
import Foundation

public final class RealmFeedStore: FeedStore {
    
    @objc(RealmCache)
    class PersistedCache: Object {
        @Persisted var timestamp: Date
        @Persisted var feed: List<PersistedFeedImage>
        
        var localFeed: [LocalFeedImage] {
            return feed.compactMap { ($0).local }
        }
    }
    
    @objc(RealmFeedImage)
    class PersistedFeedImage: Object {
        @Persisted var id: UUID
        @Persisted var imageDescription: String?
        @Persisted var location: String?
        @Persisted var urlString: String
        
        // Computed property to access as URL
        var url: URL {
            get {
                return URL(string: urlString)!
            }
            set {
                urlString = newValue.absoluteString
            }
        }
        
        internal var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
        }
    }
    
    
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
                    realm.add(self.convert(from: items, timestamp: timestamp))
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
    
    private func convert(from local: [LocalFeedImage], timestamp: Date) -> PersistedCache {
        let cache = PersistedCache()
        cache.timestamp = timestamp
        
        let realmFeedImaage = local.map { localImage -> PersistedFeedImage in
            let realImage = PersistedFeedImage()
            realImage.id = localImage.id
            realImage.imageDescription = localImage.description
            realImage.location = localImage.location
            realImage.url = localImage.url
            
            return realImage
        }
        
        cache.feed.append(objectsIn: realmFeedImaage)
        
        return cache
    }
}
