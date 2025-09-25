//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 06/09/25.
//

import Foundation

 struct RemoteFeedItem: Decodable {
     let id: UUID
     let description: String?
     let location: String?
     let image: URL
}
