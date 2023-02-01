//
//  ItemEntityProvider.swift
//  Market
//
//  Created by Casper on 25/01/2023.
//

import Foundation
import CoreData
import Combine
import Factory

protocol ItemEntityProviderProtocol {
    var itemsPublisher: CurrentValueSubject<[ItemEntity], Never> { get }
    
    func createItemEntity() -> Result<Bool, Error>
    func readAndPublishItemEntities() -> Result<Bool, Error>
    func updateItemEntity() -> Result<Bool, Error>
    func deleteItemEntity(_ item: ItemEntity) -> Result<Bool, Error>
}

class ItemEntityProvider: NSObject, ItemEntityProviderProtocol {
    
    @Injected(Container.coreDataManager) private var coreDataManager: CoreDataManagerProtocol
    
    private var fetchedResultsController: NSFetchedResultsController<ItemEntity>?
    public var itemsPublisher = CurrentValueSubject<[ItemEntity], Never>([])
    
    init(preview: Bool = false) {
        super.init()
        
        let request = ItemEntity.fetchRequest()
        request.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: coreDataManager.getManagedObjectContext(),
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        startPublishingItems()
        
        if preview {
            self.createPreviewItemEntities()
        }
        
        createItemEntity()
    }
    
    private func startPublishingItems() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            fatalError("Unable to perform fetch request for ItemEntity")
        }
    }
    
    private func createPreviewItemEntities() {
        let itemTitles = ["Milk", "Eggs", "Cheese"]
        for i in 0..<itemTitles.count {
            let item = ItemEntity(context: coreDataManager.getManagedObjectContext())
            item.id = UUID()
            item.title = itemTitles[i]
            item.quantity = Int16.random(in: 1..<20)
            item.priority = Int16.random(in: 1...3)
        }
        try? coreDataManager.getManagedObjectContext().save()
    }
    
    // MARK: - CRUD functions
    func createItemEntity() -> Result<Bool, Error> {
        let item = ItemEntity(context: coreDataManager.getManagedObjectContext())
        item.id = UUID()
        item.title = "Hey"
        do {
            try coreDataManager.getManagedObjectContext().save()
            print("Test Created")
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func readAndPublishItemEntities() -> Result<Bool, Error> {
        if let items = fetchedResultsController?.fetchedObjects {
            itemsPublisher.send(items)
            return .success(true)
        } else {
            // TODO: Error handling
            return .failure(ApplicationError.genericError)
        }
    }
    
    func updateItemEntity() -> Result<Bool, Error> {
        do {
            try coreDataManager.getManagedObjectContext().save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteItemEntity(_ item: ItemEntity) -> Result<Bool, Error> {
        coreDataManager.getManagedObjectContext().delete(item)
        do {
            try coreDataManager.getManagedObjectContext().save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
}

extension ItemEntityProvider: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let results = controller.fetchedObjects else { return }

        switch results {
            case let (items as [ItemEntity]) as Any:
                itemsPublisher.send(items)
            default:
                break
        }
    }
}
