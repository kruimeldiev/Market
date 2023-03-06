//
//  ItemRow.swift
//  Market
//
//  Created by Casper on 16/01/2023.
//

import SwiftUI

struct ItemRow: View {
    
    private var item: ItemEntity
    private var didChangeItemName: (String, String) -> Void
    private var didChangeItemPriority: (String) -> Void
    private var didChangeItemQuantity: (Int, String) -> Void
    private var toggleItemIsChecked: (String) -> Void
    
    @State private var itemTitle: String
    @State private var itemQuantity: String
    
    init(item: ItemEntity,
         didChangeItemName: @escaping (String, String) -> Void,
         didChangeItemPriority: @escaping (String) -> Void,
         didChangeItemQuantity: @escaping (Int, String) -> Void,
         toggleItemIsChecked: @escaping (String) -> Void) {
        self._itemTitle = State(initialValue: item.name)
        self._itemQuantity = State(initialValue: String(item.quantity))
        self.item = item
        self.didChangeItemName = didChangeItemName
        self.didChangeItemPriority = didChangeItemPriority
        self.didChangeItemQuantity = didChangeItemQuantity
        self.toggleItemIsChecked = toggleItemIsChecked
    }
    
    var body: some View {
        HStack(spacing: 20) {
            
            // MARK: - Check Circle
            Image(systemName: item.isChecked ? "circle.inset.filled" : "circle")
                .onTapGesture {
                    toggleItemIsChecked(item.id.uuidString)
                }
                .imageScale(.large)
            
            GeometryReader { geometry in
                HStack(spacing: 20) {
                    
                    // MARK: - Item name
                    TextField("", text: $itemTitle)
                        .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 16))
                        .foregroundColor(Color(item.isChecked
                                               ? ColorKeys.appAccentTextColor.rawValue
                                               : ColorKeys.appTextColor.rawValue))
                        .onChange(of: itemTitle) { newValue in
                            didChangeItemName(newValue, item.id.uuidString)
                        }
                        .frame(minWidth: 40)
                        .strikethrough(item.isChecked)
                        
                    // MARK: - Item quantity
                    TextField(item.quantity > 0 ? "\(item.quantity)" : "  ", text: $itemQuantity)
                        .font(.custom(FontKeys.Quicksand.regular.rawValue, size: 16))
                        .foregroundColor(Color(ColorKeys.appAccentTextColor.rawValue))
                        .keyboardType(.numberPad)
                        .onChange(of: itemQuantity) { [oldValue = item.quantity] newValue in
                            if newValue == "" { didChangeItemQuantity(0, item.id.uuidString) }
                            guard let intValue = Int(newValue) else { return }
                            if intValue >= 0 && intValue <= 999 {
                                didChangeItemQuantity(intValue, item.id.uuidString)
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
                didChangeItemPriority(item.id.uuidString)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 6)
    }
}

struct ItemRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            
            ItemRow(item: ItemEntity.shortExampleItem) { newValue, itemId in

            } didChangeItemPriority: { itemId in

            } didChangeItemQuantity: { newQuantity, itemId in

            } toggleItemIsChecked: { itemId in

            }

            ItemRow(item: ItemEntity.mediumExampleItem) { newValue, itemId in

            } didChangeItemPriority: { itemId in

            } didChangeItemQuantity: { newQuantity, itemId in

            } toggleItemIsChecked: { itemId in

            }

            ItemRow(item: ItemEntity.longExampleItem) { newValue, itemId in

            } didChangeItemPriority: { itemId in

            } didChangeItemQuantity: { newQuantity, itemId in

            } toggleItemIsChecked: { itemId in

            }
        }
    }
}
