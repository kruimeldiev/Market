//
//  SectionEntityProvider.swift
//  Market
//
//  Created by Casper on 19/02/2023.
//

import Foundation
import Factory
import CoreData
import Combine

protocol SectionEntityProviderProtocol {
    var sectionsPublisher: CurrentValueSubject<[SectionEntity], Never> { get }
    
    func createSectionEntity(title: String, imageName: String) -> Result<String, Error>
    func readAndPublishSectionEntities() -> Result<Bool, Error>
    func updateSectionEntity(_ section: SectionEntity) -> Result<Bool, Error>
    func deleteSectionEntity(_ section: SectionEntity) -> Result<Bool, Error>
    
    func addItemToSection(_ section: SectionEntity) -> Result<String, Error>
}

// TODO: Docs
class SectionEntityProvider: NSObject, SectionEntityProviderProtocol {
    
    @Injected(Container.coreDataManager) private var coreDataManager: CoreDataManagerProtocol
    
    private var fetchedResultsController: NSFetchedResultsController<SectionEntity>?
    public var sectionsPublisher = CurrentValueSubject<[SectionEntity], Never>([])
    
    init(preview: Bool = false) {
        super.init()
        
        let request = SectionEntity.fetchRequest()
        request.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: coreDataManager.getManagedObjectContext(),
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        startPublishingItems()
        
        if preview {
            self.createPreviewSectionEntities()
        }
    }
    
    private func startPublishingItems() {
        do {
            try fetchedResultsController?.performFetch()
            sectionsPublisher.send(fetchedResultsController?.fetchedObjects ?? [])
        } catch {
            fatalError("Unable to perform fetch request for SectionEntity")
        }
    }
    
    private func createPreviewSectionEntities() {
        let sectionTitles = ["Breakfast"]
        for i in 0..<sectionTitles.count {
            let section = SectionEntity(context: coreDataManager.getManagedObjectContext())
            section.id = UUID()
            section.name = sectionTitles[i]
            section.iconName = "noun_breakfast"
        }
        try? coreDataManager.getManagedObjectContext().save()
    }
    
    // MARK: - CRUD functions
    func createSectionEntity(title: String, imageName: String) -> Result<String, Error> {
        let section = SectionEntity(context: coreDataManager.getManagedObjectContext())
        let id = UUID()
        section.id = id
        section.name = title
        section.iconName = imageName
        
        do {
            try coreDataManager.getManagedObjectContext().save()
            return .success(id.uuidString)
        } catch {
            return .failure(error)
        }
    }
    
    func readAndPublishSectionEntities() -> Result<Bool, Error> {
        if let section = fetchedResultsController?.fetchedObjects {
            sectionsPublisher.send(section)
            return .success(true)
        } else {
            // TODO: Error handling
            return .failure(ApplicationError.genericError)
        }
    }
    
    func updateSectionEntity(_ section: SectionEntity) -> Result<Bool, Error> {
        do {
            try coreDataManager.getManagedObjectContext().save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteSectionEntity(_ section: SectionEntity) -> Result<Bool, Error> {
        
        for item in section.getAllItems() {
            coreDataManager.getManagedObjectContext().delete(item)
        }
        
        coreDataManager.getManagedObjectContext().delete(section)
        do {
            try coreDataManager.getManagedObjectContext().save()
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Relationships
    
    func addItemToSection(_ section: SectionEntity) -> Result<String, Error> {
        let item = ItemEntity(context: coreDataManager.getManagedObjectContext())
        let itemId = UUID()
        item.id = itemId
        item.name = ""
        item.section = section
        
        do {
            try coreDataManager.getManagedObjectContext().save()
            return .success(itemId.uuidString)
        } catch {
            return .failure(error)
        }
    }
}

extension SectionEntityProvider: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let results = controller.fetchedObjects else { return }
        
        switch results {
            case let (sections as [SectionEntity]) as Any:
                sectionsPublisher.send(sections)
            default:
                break
        }
    }
}
