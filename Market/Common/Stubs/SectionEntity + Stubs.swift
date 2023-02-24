//
//  SectionEntity + Stubs.swift
//  Market
//
//  Created by Casper on 19/02/2023.
//

import Foundation

extension SectionEntity {
    
    static var mediumExampleSection: SectionEntity {
        let section = SectionEntity(context: CoreDataManager().getManagedObjectContext())
        section.name = "Fruits & veggies"
        section.iconName = "noun_breakfast"
        return section
    }
}
