//
//  ManagedCache.swift
//  EssentialFeed
//
//  Created by Karan Sawant on 14/09/25.
//

import CoreData

@objc(ManagedCache)
internal class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
    
    var localFeed: [LocalFeedImage] {
        return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
    
    internal static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(context: context).map(context.delete)
        return ManagedCache(context: context)
    }
    
    internal static func find(context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
}
