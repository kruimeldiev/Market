//
//  ItemEntity + Previews.swift
//  Market
//
//  Created by Casper on 21/01/2023.
//

import Foundation

extension ItemEntity {
    
    static var emptyExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager().getManagedObjectContext())
        return item
    }
    
    static var shortExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager().getManagedObjectContext())
        item.name = "Lorem"
        item.quantity = 0
        item.priority = 0
        return item
    }
    
    static var mediumExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager().getManagedObjectContext())
        item.name = "Lorem ipsum dolor"
        item.quantity = 2
        item.note = "Lorem ipsum dolor sit amet"
        item.priority = 1
        return item
    }
    
    static var longExampleItem: ItemEntity {
        let item = ItemEntity(context: CoreDataManager().getManagedObjectContext())
        item.name = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        item.quantity = 18
        item.note = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        item.priority = 2
        return item
    }
}
