//
//  ListOverviewView.swift
//  Market
//
//  Created by Casper on 12/12/2022.
//

import SwiftUI

struct ListOverviewView: View {
    
    @ObservedObject var viewModel: ListOverviewViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header: Text("First section")) {
                        NavigationLink {
                            ListDetailsView()
                        } label: {
                            Text("Press me")
                        }
                        Text("Item 2")
                        Text("Item 3")
                    }
                    Section(header: Text("Second section")) {
                        Text("Item 4")
                        Text("Item 5")
                        Text("Item 6")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAllLists()
            }
        }
    }
}

struct ListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        ListOverviewView(viewModel: .init())
    }
}
