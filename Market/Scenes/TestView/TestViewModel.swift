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
    
    private var cancellable: AnyCancellable?
    
    func subscribeToItemsProvider() {
        
        cancellable = itemsProvider.itemsPublisher
            .sink { [weak self] items in
                self?.items = items
            }
        
        let test = itemsProvider.readAndUpdatePublisher()
        switch test {
            case .success:
                break
            case .failure(let failure):
                print(failure)
        }
    }
    
    func deleteTopItem(index: Int) {
        guard let item = items.last else { return }
        let result = itemsProvider.deleteItemEntity(item)
        switch result {
            case .success:
                print("Item Deleted")
            case .failure(let error):
                print(error)
        }
    }
}
