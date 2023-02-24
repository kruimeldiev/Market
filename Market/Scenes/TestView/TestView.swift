//
//  TestView.swift
//  Market
//
//  Created by Casper on 20/01/2023.
//

import SwiftUI

struct TestView: View {
    
    @StateObject var viewModel: TestViewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.items, id: \.self) { item in
                Text(item.name)
            }
            Button {
                viewModel.deleteTopItem(index: viewModel.items.count)
            } label: {
                Text("Delete top item")
            }
        }
    }
}
