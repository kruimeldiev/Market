//
//  ListOverviewView.swift
//  Market
//
//  Created by Casper on 12/12/2022.
//

import SwiftUI

struct ListOverviewView: View {
    
    @StateObject var viewModel: ListOverviewViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    TextField("Add new item here...", text: $viewModel.newItemTitle)
                        .padding(.horizontal)
                        .frame(height: 60)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    Button {
                        viewModel.addNewItem()
                    } label: {
                        Text("Add new")
                            .font(Font.custom(FontKeys.Quicksand.bold.rawValue, size: 14))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(ColorKeys.appAccentColor.rawValue))
                            .cornerRadius(12)
                    }

                    NavigationLink {
                        TestView(viewModel: .init())
                    } label: {
                        Text("Go to test")
                    }
                    
                    ScrollView {
                        ForEach(viewModel.items, id: \.self) { item in
                            HStack {
                                Text(item.title ?? "n/a")
                                    .padding(.vertical, 8)
                                Button {
                                    viewModel.deleteItem(item)
                                } label: {
                                    Text("Delete")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Groceries")
        }
        .onAppear {
            viewModel.subscribeToItemsProvider()
        }
//        onDisappear {
//            viewModel.cancelSubscriptions()
//        }
    }
}

struct ListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ListOverviewView(viewModel: .init())
    }
}
