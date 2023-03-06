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
                    
                    // MARK: - Section
                    ForEach(viewModel.sections, id: \.self) { section in
                        SectionHeader(section: section) { newValue, sectionId in
                            viewModel.updateSectionTitle(newValue: newValue, sectionId: sectionId)
                        } toggleSectionIsCollapsed: {
                            // TODO: Add collapse feature
                        } deleteSection: { sectionId in
                            viewModel.deleteSectionEntity(id: sectionId)
                        } addNewItemToSection: { sectionId in
                            viewModel.addNewItemToSection(sectionId)
                        }
                        .focused($focussedField, equals: .sectionTitleField(id: section.id.uuidString))
                        
                        // MARK: - Item in section
                        VStack(spacing: 0) {
                            ForEach(section.getAllItems(), id: \.self) { item in
                                ItemRow(item: item) { newValue, itemId in
                                    viewModel.updateItemName(newValue: newValue, itemId: itemId)
                                } didChangeItemPriority: { itemId in
                                    viewModel.changeItemPriority(itemId)
                                } didChangeItemQuantity: { newQuantity, itemId in
                                    viewModel.updateItemQuantity(newValue: newQuantity, itemId: itemId)
                                } toggleItemIsChecked: { itemId in
                                    viewModel.checkItemEntity(itemId)
                                }
                                .focused($focussedField, equals: .itemTitleField(id: item.id.uuidString))
                            }
                            .onDelete { index in
                                viewModel.deleteItemEntity(index)
                            }
                        }
                        .padding(.top, -8)
                        .padding(.bottom, 20)
                        .onTapGesture {
                            // TODO: Setup tap for new item
//                            if focussedField == nil {
//                                viewModel.addNewItemToSection(section.id.uuidString)
//                            }
                        }
                    }
                }
                .onTapGesture {
//                    if focussedField != nil {
//                        focussedField = nil
//                    }
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
