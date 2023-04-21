//
//  Container + Extensions.swift
//  Market
//
//  Created by Casper on 19/01/2023.
//

import Foundation
import Factory

extension Container {
    
    static func setupMocks() {
        coreDataManager.register { CoreDataManager(inMemory: true) }
    }
    
    static func setupPreviews() {
        coreDataManager.register { CoreDataManager(inMemory: true) }
        itemEntityProvider.register { EntityProvider(fetchRequest: ItemEntity.fetchRequest(), preview: true) }
        sectionEntityProvider.register { EntityProvider(fetchRequest: SectionEntity.fetchRequest(), preview: true) }
    }
    
    // MARK: - Core data
    static let coreDataManager = Factory(scope: .singleton) {
        CoreDataManager() as CoreDataManagerProtocol
    }
    
    // TODO: DOCS
    static let sectionEntityProvider = Factory(scope: .shared) {
        EntityProvider(fetchRequest: SectionEntity.fetchRequest())
    }
    
    static let itemEntityProvider = Factory(scope: .shared) {
        EntityProvider(fetchRequest: ItemEntity.fetchRequest())
    }
}
