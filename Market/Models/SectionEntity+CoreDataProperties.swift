//
//  SectionEntity+CoreDataProperties.swift
//  Market
//
//  Created by Casper on 24/02/2023.
//
//

import Foundation
import CoreData


extension SectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionEntity> {
        return NSFetchRequest<SectionEntity>(entityName: "SectionEntity")
    }

    @NSManaged public var iconName: String?
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension SectionEntity {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemEntity)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemEntity)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension SectionEntity : Identifiable {

}
