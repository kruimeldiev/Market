//
//  ItemEntity + Previews.swift
//  Market
//
//  Created by Casper on 21/01/2023.
//

import Foundation
import CoreData

// TODO: DOCS
extension ItemEntity {
    
    static var emptyExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        return item
    }
    
    static var shortExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        item.id = UUID()
        item.name = "Lorem"
        item.quantity = Int16.random(in: 0..<20)
        item.priority = Int16.random(in: 1..<3)
        return item
    }
    
    static var mediumExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        item.id = UUID()
        item.name = "Lorem ipsum dolor"
        item.quantity = Int16.random(in: 0..<20)
        item.note = "Lorem ipsum dolor sit amet"
        item.priority = Int16.random(in: 1..<3)
        return item
    }
    
    static var longExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        item.id = UUID()
        item.name = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        item.quantity = Int16.random(in: 0..<20)
        item.note = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        item.priority = Int16.random(in: 1..<3)
        return item
    }
    
    /// Creates an example ItemEntity and adds it to the context and SectionEntity provided
    static func createExampleItemForSection(_ section: SectionEntity,
                                            name: String,
                                            withNote: Bool) {
        guard let context = section.managedObjectContext else { return }
        let item = ItemEntity(context: context)
        item.id = UUID()
        item.name = name
        item.quantity = Int16.random(in: 0..<20)
        item.priority = Int16.random(in: 1..<3)
        if withNote { item.note = "Lorem ipsum dolor sit amet, consectetur adipiscing elit." }
        section.addToItems(item)
    }
}
