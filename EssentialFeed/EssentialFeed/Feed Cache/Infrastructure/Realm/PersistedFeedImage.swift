//
//  PersistedFeedImage.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 21/09/25.
//

import RealmSwift
import Foundation

@objc(PersistedFeedImage)
internal class PersistedFeedImage: Object {
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
