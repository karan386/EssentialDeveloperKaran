//
//  RealmFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 20/09/25.
//

import RealmSwift
import Foundation

public final class RealmFeedStore {
    
    @objc(RealmCache)
    class RealmCache: Object {
        @Persisted var timestamp: Date
        @Persisted var feed: List<RealmFeedImage>
        
        var localFeed: [LocalFeedImage] {
            return feed.compactMap { ($0).local }
        }
    }
    
    @objc(RealmFeedImage)
    class RealmFeedImage: Object {
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
    
    let queue = DispatchQueue(label: "Run realm operations", qos: .background, attributes: .concurrent)
    
    public func retrieve(completion: @escaping FeedStore.retrieveErrorCompletion) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            do {
                let realm = try Realm(configuration: Realm.Configuration(fileURL: self.storeURL, deleteRealmIfMigrationNeeded: true))
                
                if let cache = realm.objects(RealmCache.self).first {
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
    
    public func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.insertionErrorCompletion) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            do {
                let realm = try Realm(configuration: Realm.Configuration(fileURL: self.storeURL, deleteRealmIfMigrationNeeded: true))
                
                try realm.write {
                    realm.delete(realm.objects(RealmCache.self))
                    realm.add(self.convert(from: items, timestamp: timestamp))
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    private func convert(from local: [LocalFeedImage], timestamp: Date) -> RealmCache {
        let cache = RealmCache()
        cache.timestamp = timestamp
        
        let realmFeedImaage = local.map { localImage -> RealmFeedImage in
            let realImage = RealmFeedImage()
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
