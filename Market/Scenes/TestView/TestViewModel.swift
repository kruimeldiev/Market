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
    
    private var cancellable: AnyCancellable? = nil
    
    init() {
        subscribeToItemsProvider()
    }
    
    private func subscribeToItemsProvider() {
        cancellable = itemsProvider.itemsPublisher
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
