//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 11/08/25.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url =  URL(string: "https://a-url.com")!
        self.client = client
    }
    
    public func load(completion: @escaping (Result ) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return } 
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
