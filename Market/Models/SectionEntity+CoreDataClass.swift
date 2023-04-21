//
//  SectionEntity+CoreDataClass.swift
//  Market
//
//  Created by Casper on 26/03/2023.
//
//

import Foundation
import CoreData

@objc(SectionEntity)
public class SectionEntity: NSManagedObject {

    public func getAllItems() -> [ItemEntity] {
        let items = items?.allObjects as? [ItemEntity] ?? []
        return items.sorted { $0.itemIndex < $1.itemIndex }
    }
}
