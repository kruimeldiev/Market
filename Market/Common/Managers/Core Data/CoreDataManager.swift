//
//  CoreDataManager.swift
//  Market
//
//  Created by Casper on 23/01/2023.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func getManagedObjectContext() -> NSManagedObjectContext
}

// TODO: Docs
class CoreDataManager: CoreDataManagerProtocol {
    
    private var persistentContainer: NSPersistentContainer
    private let managedObjectContext: NSManagedObjectContext
    
    init(inMemory: Bool = false) {
        self.persistentContainer = NSPersistentContainer(name: "Market")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        self.managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                // TODO: Proper error handling
                print("Core data failure")
                return
            }
            print("Core Data loaded successfully")
            
            // TODO: Need this?
//            self.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext {
        self.managedObjectContext
    }
}
