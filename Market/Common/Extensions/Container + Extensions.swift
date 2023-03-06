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
        itemEntityProvider.register { ItemEntityProvider(preview: true) }
        sectionEntityProviderProvider.register { SectionEntityProvider(preview: true) }
    }
    
    // MARK: - Core data
    static let coreDataManager = Factory(scope: .singleton) {
        CoreDataManager() as CoreDataManagerProtocol
    }
    
    static let sectionEntityProviderProvider = Factory(scope: .shared) {
        SectionEntityProvider() as SectionEntityProviderProtocol
    }
    
    static let itemEntityProvider = Factory(scope: .shared) {
        ItemEntityProvider() as ItemEntityProviderProtocol
    }
}
