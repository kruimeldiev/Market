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
    
    @FocusState var focusedField: FocusableField?
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(ColorKeys.defaultBackground.rawValue)
                    .onTapGesture {
                        /// Tappable only when the ScrollView is empty
                        if viewModel.focusedField == nil { Task { await viewModel.addNewSection() } }
                    }
                
                ScrollView {
                    // MARK: - Section
                    ForEach(viewModel.sections, id: \.self) { section in
                        ZStack {
                            
                            Color(ColorKeys.defaultBackground.rawValue)
                                .onTapGesture {
                                    /// Tappable space between sections
                                    if viewModel.focusedField == nil {
                                        Task {
                                            await viewModel.addNewItemToSection(section.id)
                                        }
                                    } else {
                                        viewModel.focusedField = nil
                                    }
                                }
                            
                            VStack {
                                
                                SectionHeader(section: section) { newValue in
                                    Task {
                                        await viewModel.updateSectionTitle(newValue: newValue, sectionId: section.id)
                                    }
                                } toggleSectionIsCollapsed: {
                                    Task {
                                        await viewModel.toggleSelectionCollapseState(id: section.id)
                                    }
                                } deleteSection: {
                                    Task {
                                        await viewModel.deleteSectionEntity(id: section.id)
                                    }
                                } addNewItemToSection: {
                                    Task {
                                        await viewModel.addNewItemToSection(section.id)
                                    }
                                }
                                .focused($focusedField, equals: .sectionTitle(id: section.id))
                                
                                // MARK: - Item in section
                                if !section.isCollapsed {
                                    LazyVStack(spacing: 2) {
                                        ForEach(section.getAllItems(), id: \.self) { item in
                                            ItemRow(item: item) { newValue in
                                                Task {
                                                    await viewModel.updateItemName(newValue: newValue, itemId: item.id)
                                                }
                                            } didChangeItemQuantity: { newQuantity in
                                                Task {
                                                    await viewModel.updateItemQuantity(newValue: newQuantity, itemId: item.id)
                                                }
                                            } toggleItemIsChecked: {
                                                Task {
                                                    await viewModel.checkItemEntity(item.id)
                                                }
                                            } didDeleteItem: {
                                                Task {
                                                    await viewModel.deleteItem(item.id)
                                                }
                                            } doCreateNewItem: {
                                                Task {
                                                    await viewModel.addNewItemToSection(section.id)
                                                }
                                            }
                                            .focused($focusedField, equals: .itemTitle(id: item.id))
//                                            .focused($focusedField, equals: .itemQuantity(id: item.id))
                                            
                                            Divider()
                                                .padding(.horizontal, 20)
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    Spacer(minLength: focusedField == nil ? 80 : 20)
                }
                .onTapGesture {
                    if viewModel.focusedField == nil {
                        Task {
                            await viewModel.addNewSection()
                        }
                    } else {
                        viewModel.focusedField = nil
                    }
                }
                
                // MARK: - Plus button
                if viewModel.focusedField == nil {
                    VStack {
                        Spacer()
                        Button {
                            Task {
                                await viewModel.addNewSection()
                            }
                        } label: {
                            Text("")
                                .modifier(AppPrimaryButton(width: 60,
                                                           height: 60,
                                                           backgroundColor: Color(ColorKeys.defaultAccent.rawValue),
                                                           iconName: "plus"))
                                .shadow(color: Color(ColorKeys.defaultAccentSoft.rawValue).opacity(0.4),
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
                        // TODO: Add func to change navigationTitle
                        print("Todo: Add clear all button")
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.headline)
                            .foregroundColor(Color(ColorKeys.defaultText.rawValue))
                    }
                }
            }
            .navigationTitle("")
            .padding(.top, 20)
        }
//        .onChange(of: focusedField) { viewModel.focusedField = $0 }
        .onChange(of: viewModel.focusedField) { focusedField = $0 }
    }
}

struct ListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Container.setupPreviews()
        ListOverviewView(viewModel: .init())
    }
}
