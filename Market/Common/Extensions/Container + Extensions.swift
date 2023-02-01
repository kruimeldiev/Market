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
    }
    
    static let coreDataManager = Factory(scope: .singleton) {
        CoreDataManager() as CoreDataManagerProtocol
    }
    
    static let itemEntityProvider = Factory(scope: .shared) {
        ItemEntityProvider() as ItemEntityProviderProtocol
    }
}
