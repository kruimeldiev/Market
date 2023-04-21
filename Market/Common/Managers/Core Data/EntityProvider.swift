//
//  EntityProvider.swift
//  Market
//
//  Created by Casper on 19/04/2023.
//

import Foundation
import CoreData
import Combine
import Factory

// TODO: DOCS!!
protocol EntityProviding: AnyObject {
    
    associatedtype Entity: NSManagedObject
    
    var publisher: CurrentValueSubject<[Entity], Never> { get }
    
    @discardableResult func create(_ body: @escaping (inout Entity) -> Void) async throws -> Entity
    func read() async throws
    func update(entity: Entity) async throws
    func delete(entity: Entity) async throws
}

class EntityProvider<T: NSManagedObject>: NSObject, EntityProviding, NSFetchedResultsControllerDelegate {
    
    typealias Entity = T
    
    @Injected(Container.coreDataManager) private var coreDataManager: CoreDataManagerProtocol
    
    private var fetchedResultsController: NSFetchedResultsController<T>?
    public var publisher = CurrentValueSubject<[T], Never>([])
    
    public init(fetchRequest: NSFetchRequest<Entity>, preview: Bool = false) {
        super.init()
        
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataManager.getManagedObjectContext(),
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        
        try? read()
        
        if preview {
            self.createPreviewSectionEntities()
        }
    }
    
    private func createPreviewSectionEntities() {
        // TODO: Setup this
    }
    
    @discardableResult
    func create(_ body: @escaping (inout Entity) -> Void) async throws -> Entity {
        var entity = Entity(context: coreDataManager.getManagedObjectContext())
        body(&entity)
        try await save()
        return entity
    }
    
    func read() throws {
        try fetchedResultsController?.performFetch()
        guard let items = fetchedResultsController?.fetchedObjects else { return }
        publisher.send(items)
    }
    
    func update(entity: T) async throws {
        try await save()
    }
    
    func delete(entity: T) async throws {
        coreDataManager.getManagedObjectContext().delete(entity)
        try await save()
    }
    
    private func save() async throws {
        try await coreDataManager.getManagedObjectContext().perform {
            try self.coreDataManager.getManagedObjectContext().save()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let results = controller.fetchedObjects else { return }
        
        switch results {
            case let (entities as [T]) as Any:
                publisher.send(entities)
            default:
                break
        }
    }
}
