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
    
    func subscribeToItemsProvider() {
        cancellable = itemsProvider.getPublisher().assign(to: \.items, on: self)
        let result = itemsProvider.fetchAllItems()
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    // TODO: Dit werkt niet helemaal
    func cancelSubscriptions() {
        cancellable = nil
    }
    
    func addNewItem() {
        guard newItemTitle != "" else { return }
        let result = itemsProvider.addNewItem(title: newItemTitle)
        switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: Error handling
                print(error)
        }
    }
    
    func deleteItem(_ item: ItemEntity) {
        let result = itemsProvider.deleteItemEntity(item)
        switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
        }
    }
}
