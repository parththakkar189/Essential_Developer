//
//  CoreDataHelpers.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-06-01.
//

import CoreData

internal extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case persistentStoreNotFound
    }
    
    static func load(
        modelName name: String,
        url: URL,
        model: NSManagedObjectModel
    ) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        
        try loadError.map { throw $0 }
        
        return container
    }
}

extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
