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
                        VStack {
                            SectionHeader(section: section) { newValue in
                                viewModel.updateSectionTitle(newValue: newValue, sectionId: section.id)
                            } toggleSectionIsCollapsed: {
                                // TODO: Add collapse feature
                            } deleteSection: {
                                viewModel.deleteSectionEntity(id: section.id)
                            } addNewItemToSection: {
                                viewModel.addNewItemToSection(section.id)
                            }
                            .focused($focussedField, equals: .sectionTitleField(id: section.id.uuidString))
                            
                            // MARK: - Item in section
                            LazyVStack(spacing: 2) {
                                ForEach(section.getAllItems(), id: \.self) { item in
                                    ItemRow(item: item) { newValue in
                                        viewModel.updateItemName(newValue: newValue, itemId: item.id)
                                    } didChangeItemPriority: {
                                        viewModel.changeItemPriority(item.id)
                                    } didChangeItemQuantity: { newQuantity in
                                        viewModel.updateItemQuantity(newValue: newQuantity, itemId: item.id)
                                    } toggleItemIsChecked: {
                                        viewModel.checkItemEntity(item.id)
                                    } didDeleteItem: {
                                        viewModel.deleteItem(item.id)
                                    }
                                    .focused($focussedField, equals: .itemTitleField(id: item.id.uuidString))
                                    
                                    // TODO: Remove bottom divider?
                                    Divider()
                                        .padding(.horizontal, 20)
                                }
                            }
                            .padding(.top, -8)
                            .padding(.bottom, 20)
                        }
                        .onTapGesture {
                            viewModel.addNewItemToSection(section.id)
                        }
                    }
                }
                .onTapGesture {
                    if focussedField != nil {
                        focussedField = nil
                    }
                }
                
                // MARK: - Plus button
                if focussedField == nil {
                    VStack {
                        Spacer()
                        Button {
                            viewModel.addNewSection()
                        } label: {
                            Text("")
                                .modifier(AppPrimaryButton(width: 60,
                                                           height: 60,
                                                           backgroundColor: Color(ColorKeys.defaultAccent.rawValue),
                                                           iconName: "plus"))
                                .shadow(color: Color(ColorKeys.defaultAccentSoft.rawValue).opacity(0.6),
                                        radius: 20)
                        }
                        .padding(40)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Add clear all button
                        print("Todo: Add clear all button")
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.headline)
                            .foregroundColor(.gray)
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
