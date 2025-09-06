//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 06/09/25.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
