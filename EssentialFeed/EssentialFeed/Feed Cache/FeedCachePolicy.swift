//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 08/09/25.
//

import Foundation

 final class FeedCachePolicy {
    private init() {}
    
    static private let calendar = Calendar(identifier: .gregorian)
    
    static private var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
