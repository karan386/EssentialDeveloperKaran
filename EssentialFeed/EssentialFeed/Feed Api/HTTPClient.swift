//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 15/08/25.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

/// The completion handler can be invoked in any thread.
/// Clients are responsible to dispatch to appropriate threads, if needed.
public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
