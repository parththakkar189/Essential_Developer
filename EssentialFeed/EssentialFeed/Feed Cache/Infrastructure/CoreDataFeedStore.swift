//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-05-19.
//

import Foundation
import CoreData

public final class CoreDataFeedStore {
    private static let modelName = "FeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
        
        private let container: NSPersistentContainer
        private let context: NSManagedObjectContext

        enum StoreError: Error {
            case modelNotFound
            case failedToLoadPersistentContainer(Error)
        }

        public init(storeURL: URL) throws {
            guard let model = CoreDataFeedStore.model else {
                throw StoreError.modelNotFound
            }
            
            do {
                container = try NSPersistentContainer.load(modelName: CoreDataFeedStore.modelName, url: storeURL, model: model)
                context = container.newBackgroundContext()
            } catch {
                throw StoreError.failedToLoadPersistentContainer(error)
            }
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
