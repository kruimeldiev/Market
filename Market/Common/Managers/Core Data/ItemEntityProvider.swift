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
    var itemsPublisher: PassthroughSubject<[ItemEntity], Never> { get }
    
    func createItemEntity(title: String) -> Result<Bool, Error>
    func readAndUpdatePublisher() -> Result<Bool, Error>
    func updateItemEntity() -> Result<Bool, Error>
    func deleteItemEntity(_ item: ItemEntity) -> Result<Bool, Error>
}

class ItemEntityProvider: NSObject, ItemEntityProviderProtocol {
    
    @Injected(Container.coreDataManager) private var coreDataManager: CoreDataManagerProtocol
    
    private var fetchedResultsController: NSFetchedResultsController<ItemEntity>?
    public var itemsPublisher = PassthroughSubject<[ItemEntity], Never>()
    
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
            fatalError("Unable to perform fetch request for ItemEntity")
        }
    }
    
    // MARK: - CRUD functions
    func createItemEntity(title: String) -> Result<Bool, Error> {
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
    
    func readAndUpdatePublisher() -> Result<Bool, Error> {
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
