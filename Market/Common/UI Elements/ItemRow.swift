//
//  ItemRow.swift
//  Market
//
//  Created by Casper on 16/01/2023.
//

import SwiftUI

struct ItemRow: View {
    
    private var item: ItemEntity
    private var didChangeItemName: (String) -> Void
    private var didChangeItemQuantity: (String) -> Void
    private var toggleItemIsChecked: () -> Void
    private var didDeleteItem: () -> Void
    private var doCreateNewItem: () -> Void
    
    @State private var itemTitle: String
    @State private var itemQuantity: String
    
    @FocusState var focusedField: FocusableField?
    
    init(item: ItemEntity,
         didChangeItemName: @escaping (String) -> Void,
         didChangeItemQuantity: @escaping (String) -> Void,
         toggleItemIsChecked: @escaping () -> Void,
         didDeleteItem: @escaping () -> Void,
         doCreateNewItem: @escaping () -> Void) {
        self._itemTitle = State(initialValue: item.name)
        self._itemQuantity = State(initialValue: item.quantity)
        self.item = item
        self.didChangeItemName = didChangeItemName
        self.didChangeItemQuantity = didChangeItemQuantity
        self.toggleItemIsChecked = toggleItemIsChecked
        self.didDeleteItem = didDeleteItem
        self.doCreateNewItem = doCreateNewItem
    }
    
    var body: some View {
        HStack(spacing: 20) {
            
            // MARK: - Check Circle
            ZStack {
                Image(systemName: item.isChecked ? "circle.fill" : "circle")
                    .foregroundColor(item.isChecked
                                     ? Color(ColorKeys.defaultAccentSoft.rawValue)
                                     : .gray)
                    .onTapGesture {
                        toggleItemIsChecked()
                    }
                    .imageScale(.large)
                if item.isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(ColorKeys.defaultAccent.rawValue))
                        .imageScale(.small)
                }
            }
            
            // MARK: - Item name
            TextField("", text: $itemTitle, axis: .horizontal)
                .focused($focusedField, equals: .itemTitle(id: item.id))
                .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 16))
                .foregroundColor(Color(item.isChecked
                                       ? ColorKeys.accentText.rawValue
                                       : ColorKeys.defaultText.rawValue))
                .lineLimit(3)
                .frame(minWidth: 40)
                .strikethrough(item.isChecked)
                .gesture(TapGesture().onEnded { _ in
                    /// This TapGesture is needed for selecting the TextField
                })
                .onChange(of: itemTitle) { newValue in
                    didChangeItemName(newValue)
                }
            // TODO: Check deze link voor submit: https://www.reddit.com/r/SwiftUI/comments/zobpfu/how_to_submit_textfield_with_vertical_axis/
                .onSubmit {
                    if item.name == "" {
                        didDeleteItem()
                    } else if item.quantity == "" {
                        focusedField = .itemQuantity(id: item.id)
                    } else {
                        doCreateNewItem()
                    }
                }
            
            // MARK: - Item quantity
            TextField("", text: $itemQuantity)
                .focused($focusedField, equals: .itemQuantity(id: item.id))
                .font(.custom(FontKeys.Quicksand.regular.rawValue, size: 16))
                .foregroundColor(Color(ColorKeys.accentText.rawValue))
                .frame(width: 64)
                .gesture(TapGesture().onEnded { _ in
                    /// This TapGesture is needed for selecting the TextField
                })
                .onChange(of: itemQuantity) { newValue in
                    didChangeItemQuantity(newValue)
                }
                .onSubmit {
                    if item.section.getAllItems().last?.itemIndex == item.itemIndex {
                        doCreateNewItem()
                    } else {
                        // TODO: select next item
                        focusedField = nil
                    }
                }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Color(ColorKeys.defaultBackground.rawValue))
        .contentShape(Rectangle())
        .modifier(SwipeableView  {
            didDeleteItem()
        })
    }
}

struct ItemRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            
            ItemRow(item: ItemEntity.shortExampleItem) { newValue in

            } didChangeItemQuantity: { newQuantity in

            } toggleItemIsChecked: {

            } didDeleteItem: {
                
            } doCreateNewItem: {
                
            }

            ItemRow(item: ItemEntity.mediumExampleItem) { newValue in

            } didChangeItemQuantity: { newQuantity in

            } toggleItemIsChecked: {

            } didDeleteItem: {
                
            } doCreateNewItem: {
                
            }

            ItemRow(item: ItemEntity.longExampleItem) { newValue in

            } didChangeItemQuantity: { newQuantity in

            } toggleItemIsChecked: {

            } didDeleteItem: {
                
            } doCreateNewItem: {
                
            }
        }
    }
}
