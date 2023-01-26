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
    func getPublisher() -> PassthroughSubject<[ItemEntity], Never>
    func fetchAllItems() -> Result<Bool, Error>
    func addNewItem(title: String) -> Result<Bool, Error>
    func deleteItemEntity(_ item: ItemEntity) -> Result<Bool, Error>
}

class ItemEntityProvider: NSObject, ItemEntityProviderProtocol {
    
    @Injected(Container.coreDataManager) private var coreDataManager: CoreDataManagerProtocol
    
    private var fetchedResultsController: NSFetchedResultsController<ItemEntity>?
    
    private var itemsPublisher = PassthroughSubject<[ItemEntity], Never>()
    
    override init() {
        super.init()
        
        let request = ItemEntity.fetchRequest()
        request.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: coreDataManager.getManagedObjectContext(),
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        startPublishingItems()
    }
    
    private func startPublishingItems() {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // TODO: Error handling
            print("Publishing error: \(error)")
        }
    }
    
    func getPublisher() -> PassthroughSubject<[ItemEntity], Never> {
        return itemsPublisher
    }
    
    // MARK: - Protocol functions
    func fetchAllItems() -> Result<Bool, Error> {
        if let items = fetchedResultsController?.fetchedObjects {
            print("Items Fetched: \(items.count)")
            itemsPublisher.send(items)
            return .success(true)
        } else {
            // TODO: Error handling
            return .failure(ApplicationError.genericError)
        }
    }
    
    func addNewItem(title: String) -> Result<Bool, Error> {
        let item = ItemEntity(context: coreDataManager.getManagedObjectContext())
        item.id = UUID()
        item.title = title

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
