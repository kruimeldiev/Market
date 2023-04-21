//
//  ItemEntity + Previews.swift
//  Market
//
//  Created by Casper on 21/01/2023.
//

import Foundation
import CoreData

// TODO: UPDATE THIS IS OLD
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
        item.quantity = "\(Int16.random(in: 0..<20)) liter"
        return item
    }
    
    static var mediumExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        item.id = UUID()
        item.name = "Lorem ipsum dolor"
        item.quantity = "\(Int16.random(in: 0..<20)) gram"
        return item
    }
    
    static var longExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        item.id = UUID()
        item.name = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        item.quantity = "\(Int16.random(in: 0..<20)) kilo"
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
        item.quantity = "\(Int16.random(in: 0..<20)) aantal"
        item.itemIndex = 1
        section.addToItems(item)
    }
}
