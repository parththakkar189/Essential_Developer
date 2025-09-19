//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-05-19.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {
    
    private let container: NSPersistentContainer
    
    private let context: NSManagedObjectContext
    
    public init(
        storeURL: URL
    ) throws {
        let bundle = Bundle(for: Self.self)
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    func cleanUpReferencesToPresistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove(_:))
        }
    }
    
    deinit {
        cleanUpReferencesToPresistentStores()
    }
}
