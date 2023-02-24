//
//  SectionEntity+CoreDataClass.swift
//  Market
//
//  Created by Casper on 24/02/2023.
//
//

import Foundation
import CoreData

@objc(SectionEntity)
public class SectionEntity: NSManagedObject {

    public func getAllItems() -> [ItemEntity] {
        // TODO: Don't we need error handling for this?
        return items?.allObjects as? [ItemEntity] ?? []
    }
}
