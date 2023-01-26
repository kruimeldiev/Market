//
//  TestViewModel.swift
//  Market
//
//  Created by Casper on 20/01/2023.
//

import Foundation
import Factory
import CoreData
import Combine

class TestViewModel: ObservableObject {
    
    @Injected(Container.itemEntityProvider) private var itemsProvider: ItemEntityProviderProtocol
    
    @Published var items = [ItemEntity]()
    
    private weak var cancellable: AnyCancellable? = nil
    
    // TODO: Is deinit best way yo handle this?
    deinit {
        print("Deinit Test VM")
    }
    
    func subscribeToItemsProvider() {
        cancellable = itemsProvider.getPublisher().assign(to: \.items, on: self)
        itemsProvider.fetchAllItems()
    }
    
    func cancelSubscriptions() {
        cancellable = nil
    }
    
    func deleteTopItem(index: Int) {
        guard let item = items.last else { return }
        itemsProvider.deleteItemEntity(item)
    }
}
