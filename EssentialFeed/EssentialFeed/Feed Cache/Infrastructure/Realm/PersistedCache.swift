//
//  PersistedCache.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 21/09/25.
//

import RealmSwift
import Foundation

@objc(PersistedCache)
internal class PersistedCache: Object {
    @Persisted var timestamp: Date
    @Persisted var feed: List<PersistedFeedImage>
    
    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0).local }
    }
}

extension PersistedCache {
    internal static func convert(from local: [LocalFeedImage], timestamp: Date) -> PersistedCache {
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
