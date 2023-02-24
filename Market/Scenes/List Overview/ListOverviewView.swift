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
    
    @FocusState var focussedField: FocusField?
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(viewModel.sections, id: \.self) { section in
                        SectionHeader(section: section) { newValue, sectionId in
                            viewModel.updateSectionTitle(newValue: newValue, sectionId: sectionId)
                        } toggleSectionIsCollapsed: {
                            // TODO: Add collapse feature
                        } deleteSection: { sectionId in
                            viewModel.deleteSectionEntity(id: sectionId)
                        } addNewItemToSection: { sectionId in
                            viewModel.addNewItemToSection(id: sectionId)
                        }
                        .focused($focussedField, equals: .sectionTitleField(id: section.id.uuidString))
                        
                        ForEach(section.getAllItems(), id: \.self) { item in
                            ItemRow(item: item) {
                                viewModel.checkItemEntity(item)
                            }
                            .focused($focussedField, equals: .itemTitleField(id: item.id.uuidString))
                        }
                    }
                    
                    Text("\(viewModel.items.count)")
                }
                .onTapGesture {
                    // TODO: Add new item in aisle
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.addNewSection()
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.headline)
                                .foregroundColor(Color(ColorKeys.appTextColor.rawValue))
                        }
                }
            }
            .navigationTitle("Groceries")
        }
        .onChange(of: viewModel.listOverviewFocusState) { focussedField = $0 }
    }
}

struct ListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.setupPreviews()
        ListOverviewView(viewModel: .init())
    }
}
