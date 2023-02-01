//
//  ListOverviewView.swift
//  Market
//
//  Created by Casper on 12/12/2022.
//

import SwiftUI
import Factory

struct ListOverviewView: View {
    
    @StateObject var viewModel: ListOverviewViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    TextField("Title", text: $viewModel.newItemTitle)
                        .padding()
                        .onSubmit {
                            viewModel.addNewItem()
                        }
                    NavigationLink("Link") {
                        TestView(viewModel: .init())
                    }
                    ForEach(viewModel.items, id: \.self) { item in
                        Text(item.title ?? "empty")
//                        ItemRow(item: item) {
//                            viewModel.checkItemEntity(item)
//                        }
                    }
                }
            }
            .navigationTitle("Groceries")
        }
    }
}

struct ListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.setupPreviews()
        ListOverviewView(viewModel: .init())
    }
}
