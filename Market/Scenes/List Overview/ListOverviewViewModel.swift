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
    
    private var cancellable: AnyCancellable? = nil
    
    @Published var newItemTitle = ""
    @Published var items = [ItemEntity]()
    
    /// Subscribes to the ItemsProvider with a weak reference
    func subscribeToItemsProvider() {
        cancellable = itemsProvider.itemsPublisher
            .sink { [weak self] items in
                self?.items = items
            }
        let result = itemsProvider.readAndUpdatePublisher()
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func addNewItem() {
        guard newItemTitle != "" else { return }
        let result = itemsProvider.createItemEntity(title: newItemTitle)
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func deleteItemEntity(_ item: ItemEntity) {
        let result = itemsProvider.deleteItemEntity(item)
        switch result {
            case .success:
                print("Item deleted")
            case .failure(let error):
                print(error)
        }
    }
    
    func checkItemEntity(_ item: ItemEntity) {
        item.isChecked.toggle()
        let result = itemsProvider.updateItemEntity()
        switch result {
            case .success:
                print("Item updated")
            case .failure(let error):
                print(error)
        }
    }
}
