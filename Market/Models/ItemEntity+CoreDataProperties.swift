//
//  ItemEntity+CoreDataProperties.swift
//  Market
//
//  Created by Casper on 26/03/2023.
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
    @NSManaged public var quantity: String
    @NSManaged public var section: SectionEntity
    @NSManaged public var itemIndex: Int16

}

extension ItemEntity : Identifiable {

}
