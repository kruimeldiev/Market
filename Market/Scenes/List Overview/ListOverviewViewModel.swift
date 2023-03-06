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
        let result = sectionsProvider.createSectionEntity(title: "", imageName: IconKeys.groceries.rawValue)
        switch result {
            case .success(let id):
                listOverviewFocusState = .sectionTitleField(id: id)
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func updateSectionTitle(newValue: String, sectionId: String) {
        guard let section = sections.first(where: { $0.id.uuidString == sectionId }) else { return }
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
    
    func deleteSectionEntity(id: String) {
        guard let section = sections.first(where: { $0.id.uuidString == id }) else { return }
        let result = sectionsProvider.deleteSectionEntity(section)
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func addNewItemToSection(_ sectionId: String) {
        guard let section = sections.first(where: { $0.id.uuidString == sectionId }) else { return }
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
    func updateItemName(newValue: String, itemId: String) {
        guard let item = items.first(where: { $0.id.uuidString == itemId }) else { return }
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
    
    func updateItemQuantity(newValue: Int, itemId: String) {
        guard let item = items.first(where: { $0.id.uuidString == itemId }) else { return }
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
    
    func deleteItemEntity(_ index: IndexSet) {
        guard let item = index.map({ self.items[$0] }).first else { return }
        let result = itemsProvider.deleteItemEntity(item)
        switch result {
            case .success:
                print("Item deleted")
            case .failure(let error):
                print(error)
        }
    }
    
    func checkItemEntity(_ itemId: String) {
        guard let item = items.first(where: { $0.id.uuidString == itemId }) else { return }
        item.isChecked.toggle()
        let result = itemsProvider.updateItemEntity()
        switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
        }
    }
    
    func changeItemPriority(_ itemId: String) {
        guard let item = items.first(where: { $0.id.uuidString == itemId }) else { return }
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
