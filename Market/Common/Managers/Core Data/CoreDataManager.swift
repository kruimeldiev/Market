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

class CoreDataManager: CoreDataManagerProtocol {
    
    private var persistentContainer: NSPersistentContainer
    private let managedObjectContext: NSManagedObjectContext
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "Market")
        self.managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                // TODO: Proper error handling
                print("Core data failure")
                return
            }
            print("Core Data loaded successfully")
        }
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext {
        self.managedObjectContext
    }
}
