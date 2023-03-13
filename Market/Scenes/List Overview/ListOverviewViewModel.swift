//
//  ListOverviewViewModel.swift
//  Market
//
//  Created by Casper on 12/12/2022.
//

import SwiftUI
import Factory
import Combine

class ListOverviewViewModel: ObservableObject {
    
    @Injected(Container.itemEntityProvider) private var itemsProvider: ItemEntityProviderProtocol
    @Injected(Container.sectionEntityProviderProvider) private var sectionsProvider: SectionEntityProviderProtocol
    
    private var sectionsCancellable: AnyCancellable? = nil
    private var itemsCancellable: AnyCancellable? = nil
    
    @Published var items = [ItemEntity]()
    @Published var sections = [SectionEntity]()
    
    @Published var listOverviewFocusState: FocusField?
    
    init() {
        subscribeToItemsProvider()
        subscribeToSectionsProvider()
    }
    
    private func subscribeToSectionsProvider() {
        sectionsCancellable = sectionsProvider.sectionsPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // TODO: Error handling
                        print(error)
                }
            }, receiveValue: { [weak self] sections in
                self?.sections = sections
            })
    }
    
    /// Subscribes to the ItemsProvider with a weak reference
    private func subscribeToItemsProvider() {
        itemsCancellable = itemsProvider.itemsPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // TODO: Error handling
                        print(error)
                }
            }, receiveValue: { [weak self] items in
                self?.items = items
            })
    }
    
    // MARK: - SectionEntity Fucntions
    func addNewSection() {
        // TODO: Remove image name. also from CoreData
        let result = sectionsProvider.createSectionEntity(title: "", imageName: "")
        switch result {
            case .success(let id):
                listOverviewFocusState = .sectionTitleField(id: id)
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func updateSectionTitle(newValue: String, sectionId: UUID) {
        guard let section = sections.first(where: { $0.id == sectionId }) else { return }
        section.name = newValue
        let result = sectionsProvider.updateSectionEntity(section)
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func deleteSectionEntity(id: UUID) {
        guard let section = sections.first(where: { $0.id == id }) else { return }
        let result = sectionsProvider.deleteSectionEntity(section)
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func addNewItemToSection(_ sectionId: UUID) {
        guard let section = sections.first(where: { $0.id == sectionId }) else { return }
        let result = sectionsProvider.addItemToSection(section)
        switch result {
            case .success(let id):
                listOverviewFocusState = .itemTitleField(id: id)
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    // MARK: - ItemEntity Functions
    func updateItemName(newValue: String, itemId: UUID) {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.name = newValue
        let result = itemsProvider.updateItemEntity()
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func updateItemQuantity(newValue: Int, itemId: UUID) {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.quantity = Int16(newValue)
        let result = itemsProvider.updateItemEntity()
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func deleteItem(_ itemId: UUID) {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        let result = itemsProvider.deleteItemEntity(item)
        switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
        }
    }
    
    func checkItemEntity(_ itemId: UUID) {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.isChecked.toggle()
        let result = itemsProvider.updateItemEntity()
        switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
        }
    }
    
    func changeItemPriority(_ itemId: UUID) {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.priority = (item.priority >= 0 && item.priority <= 2) ? item.priority + 1 : 0
        let result = itemsProvider.updateItemEntity()
        switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
        }
    }
}
