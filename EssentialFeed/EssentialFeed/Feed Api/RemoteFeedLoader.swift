//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 11/08/25.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url =  URL(string: "https://a-url.com")!
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}

