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
    private var didChangeItemPriority: () -> Void
    private var didChangeItemQuantity: (Int) -> Void
    private var toggleItemIsChecked: () -> Void
    private var didDeleteItem: () -> Void
    
    @State private var itemTitle: String
    @State private var itemQuantity: String
    
    init(item: ItemEntity,
         didChangeItemName: @escaping (String) -> Void,
         didChangeItemPriority: @escaping () -> Void,
         didChangeItemQuantity: @escaping (Int) -> Void,
         toggleItemIsChecked: @escaping () -> Void,
         didDeleteItem: @escaping () -> Void) {
        self._itemTitle = State(initialValue: item.name)
        self._itemQuantity = State(initialValue: String(item.quantity))
        self.item = item
        self.didChangeItemName = didChangeItemName
        self.didChangeItemPriority = didChangeItemPriority
        self.didChangeItemQuantity = didChangeItemQuantity
        self.toggleItemIsChecked = toggleItemIsChecked
        self.didDeleteItem = didDeleteItem
    }
    
    var body: some View {
        HStack(spacing: 20) {
            
            // MARK: - Check Circle
//            Image(systemName: item.isChecked ? "circle.inset.filled" : "circle")
//                .onTapGesture {
//                    toggleItemIsChecked()
//                }
//                .imageScale(.large)
            
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
            
            GeometryReader { geometry in
                HStack(spacing: 20) {
                    
                    // MARK: - Item name
                    TextField("", text: $itemTitle)
                        .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 16))
                        .foregroundColor(Color(item.isChecked
                                               ? ColorKeys.accentText.rawValue
                                               : ColorKeys.defaultText.rawValue))
                        .onChange(of: itemTitle) { newValue in
                            didChangeItemName(newValue)
                        }
                        .frame(minWidth: 40)
                        .strikethrough(item.isChecked)
                    
                    // MARK: - Item quantity
                    TextField(item.quantity > 0 ? "\(item.quantity)" : "  ", text: $itemQuantity)
                        .font(.custom(FontKeys.Quicksand.regular.rawValue, size: 16))
                        .foregroundColor(Color(ColorKeys.accentText.rawValue))
                        .keyboardType(.numberPad)
                        .onChange(of: itemQuantity) { [oldValue = item.quantity] newValue in
                            if newValue == "" { didChangeItemQuantity(0) }
                            guard let intValue = Int(newValue) else { return }
                            if intValue >= 0 && intValue <= 999 {
                                didChangeItemQuantity(intValue)
                            } else {
                                itemQuantity = String(oldValue)
                            }
                        }
                        .onAppear {
                            itemQuantity = item.quantity > 0 ? "\(item.quantity)" : ""
                        }
                        .frame(width: 32)
                }
                .frame(maxWidth: geometry.size.width, maxHeight: .infinity)
                .fixedSize(horizontal: true, vertical: false)
            }
            
            // MARK: - Item priority
            Group {
                switch item.priority {
                    case 1:
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 14)
                    case 2:
                        Circle()
                            .foregroundColor(.orange)
                            .frame(width: 14)
                    case 3:
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 14)
                    default:
                        Circle()
                            .foregroundColor(.gray.opacity(0.2))
                            .frame(width: 14)
                }
            }
            .onTapGesture {
                didChangeItemPriority()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 6)
        .background(Color(ColorKeys.defaultBackground.rawValue))
        .contentShape(Rectangle())
        .modifier(SwipeableView(callback: {
            didDeleteItem()
        }))
    }
}

struct ItemRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            
            ItemRow(item: ItemEntity.shortExampleItem) { newValue in

            } didChangeItemPriority: {

            } didChangeItemQuantity: { newQuantity in

            } toggleItemIsChecked: {

            } didDeleteItem: {
                
            }

            ItemRow(item: ItemEntity.mediumExampleItem) { newValue in

            } didChangeItemPriority: {

            } didChangeItemQuantity: { newQuantity in

            } toggleItemIsChecked: {

            } didDeleteItem: {
                
            }

            ItemRow(item: ItemEntity.longExampleItem) { newValue in

            } didChangeItemPriority: {

            } didChangeItemQuantity: { newQuantity in

            } toggleItemIsChecked: {

            } didDeleteItem: {
                
            }
        }
    }
}
