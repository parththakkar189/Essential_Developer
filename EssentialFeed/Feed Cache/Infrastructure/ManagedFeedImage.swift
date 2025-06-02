//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-06-01.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    static func images(
        from local: [LocalFeedImage],
        in context: NSManagedObjectContext
    ) -> NSOrderedSet {
        let managedImages = local.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        }
        return NSOrderedSet(array: managedImages)
    }
    var local: LocalFeedImage {
        return LocalFeedImage(
            id: id,
            description: imageDescription,
            location: location,
            url: url
        )
    }
}
