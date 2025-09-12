//
//  CodableFeedStore.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 11/09/25.
//

import Foundation

public class CodableFeedStore: FeedStore {
    
    private let storeURL: URL
    
    public init(_ storeURL: URL) {
        self.storeURL = storeURL
    }
        
    private struct Cache: Codable {
        var feed: [CodableFeedImage]
        var timestamp : Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        let id: UUID
        let description: String?
        let location: String?
        let url: URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    public func retrieve(completion: @escaping retrieveErrorCompletion){
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            let decoder = JSONDecoder()
            do {
                let cache = try decoder.decode(Cache.self, from: data)
                return completion(.found(cache.localFeed, cache.timestamp))
            } catch {
                return completion(.failure(error))
            }
        }
    }
    
    public func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping insertionErrorCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let encoded = try! encoder.encode(Cache(feed: items.map(CodableFeedImage.init), timestamp: timestamp))
                try encoded.write(to: storeURL)
                return completion(nil)
            } catch {
                return completion(error)
            }
        }
    }
    
    public func deleteCachedFeed(completion: @escaping deletionErrorCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
