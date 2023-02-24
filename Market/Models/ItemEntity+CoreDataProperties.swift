//
//  ItemEntity+CoreDataProperties.swift
//  Market
//
//  Created by Casper on 24/02/2023.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var isChecked: Bool
    @NSManaged public var name: String
    @NSManaged public var note: String?
    @NSManaged public var priority: Int16
    @NSManaged public var quantity: Int16
    @NSManaged public var section: SectionEntity?

}

extension ItemEntity : Identifiable {

}
