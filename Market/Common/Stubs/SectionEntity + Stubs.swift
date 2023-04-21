//
//  SectionEntity + Stubs.swift
//  Market
//
//  Created by Casper on 19/02/2023.
//

import Foundation
import CoreData

// TODO: UPDATE THIS IS OLD
// TODO: Docs!!
extension SectionEntity {
    
    static var mediumExampleSection: SectionEntity {
        let section = SectionEntity(context: CoreDataManager(inMemory: true).getManagedObjectContext())
        section.id = UUID()
        section.name = "Fruits & veggies"
        section.sectionIndex = Int16(Int.random(in: 0...999))
        section.isCollapsed = false
        return section
    }
    
    /// Creates an example SectionEntity with ItemEntities to be used for testing and previewing
    static func createExampleWithObjectContext(_ context: NSManagedObjectContext,
                                               name: String) {
        let section = SectionEntity(context: context)
        section.id = UUID()
        section.name = name
        section.sectionIndex = Int16(Int.random(in: 0...999))
        section.isCollapsed = false
        let itemTitles = ["Milk", "Eggs", "Cheese"]
        for i in 0..<itemTitles.count {
            ItemEntity.createExampleItemForSection(section,
                                                   name: itemTitles[i],
                                                   withNote: Bool.random())
        }
    }
}
