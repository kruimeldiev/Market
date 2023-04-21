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
    
    @Injected(Container.itemEntityProvider) private var itemsProvider: EntityProvider<ItemEntity>
    @Injected(Container.sectionEntityProvider) private var sectionsProvider: EntityProvider<SectionEntity>
    
    private var cancellebles = Set<AnyCancellable>()
    
    @Published var items = [ItemEntity]()
    @Published var sections = [SectionEntity]()
    
    @Published var focusedField: FocusableField?
    
    init() {
        subscribeToItemsProvider()
        subscribeToSectionsProvider()
    }
    
    private func subscribeToSectionsProvider() {
        sectionsProvider.publisher
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // TODO: Error handling
                        print(error)
                }
            } receiveValue: { [weak self] sections in
                self?.sections = sections.sorted { $0.sectionIndex < $1.sectionIndex }
            }
            .store(in: &cancellebles)
    }
    
    private func subscribeToItemsProvider() {
        itemsProvider.publisher
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        // TODO: Error handling
                        print(error)
                }
            } receiveValue: { [weak self] items in
                // TODO: Sort by index
                self?.items = items
            }
            .store(in: &cancellebles)
    }
    
    // MARK: - SectionEntity Fucntions
    func addNewSection() async {
        do {
            let newSection = try await sectionsProvider.create { section in
                section.id = UUID()
                section.name = ""
                section.isCollapsed = false
                section.sectionIndex = Int16(self.sections.count + 1)
            }
            await MainActor.run(body: {
                self.focusedField = .sectionTitle(id: newSection.id)
            })
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func updateSectionTitle(newValue: String, sectionId: UUID) async {
        guard let section = sections.first(where: { $0.id == sectionId }) else { return }
        section.name = newValue
        
        do {
            try await sectionsProvider.update(entity: section)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func deleteSectionEntity(id: UUID) async {
        guard let section = sections.first(where: { $0.id == id }) else { return }
        
        do {
            try await sectionsProvider.delete(entity: section)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func toggleSelectionCollapseState(id: UUID) async {
        guard let section = sections.first(where: { $0.id == id }) else { return }
        section.isCollapsed.toggle()
        
        do {
            try await sectionsProvider.update(entity: section)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    // MARK: - ItemEntity Functions
    func addNewItemToSection(_ sectionId: UUID) async {
        guard let section = sections.first(where: { $0.id == sectionId }) else { return }
        do {
            let newItem = try await itemsProvider.create { item in
                item.id = UUID()
                item.name = ""
                item.section = section
                item.quantity = ""
                item.itemIndex = Int16(section.getAllItems().count + 1)
            }
            await MainActor.run(body: {
                self.focusedField = .itemTitle(id: newItem.id)
            })
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func updateItemName(newValue: String, itemId: UUID) async {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.name = newValue
        do {
            try await itemsProvider.update(entity: item)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func updateItemQuantity(newValue: String, itemId: UUID) async {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.quantity = newValue
        do {
            try await itemsProvider.update(entity: item)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func checkItemEntity(_ itemId: UUID) async {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        item.isChecked.toggle()
        do {
            try await itemsProvider.update(entity: item)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    func deleteItem(_ itemId: UUID) async {
        guard let item = items.first(where: { $0.id == itemId }) else { return }
        do {
            try await itemsProvider.delete(entity: item)
        } catch {
            // TODO: Error handling
            print(error)
        }
    }
    
    // MARK: - Miscelanious
    
    // TODO: Needed?
//    func deleteEmptyItemsIfNeeded() async {
//        let emptyItems = items.filter { item in
//            item.name.isEmpty && item.quantity.isEmpty
//        }
//        for item in emptyItems {
//            await deleteItem(item.id)
//        }
//        listOverviewFocusState = nil
//    }
}
