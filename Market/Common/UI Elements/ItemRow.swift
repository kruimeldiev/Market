//
//  ItemRow.swift
//  Market
//
//  Created by Casper on 16/01/2023.
//

import SwiftUI

struct ItemRow: View {
    
    private var item: ItemEntity
    private var toggleIsChecked: () -> Void
    
    @State private var titleInputString: String
    
    init(item: ItemEntity, toggleIsChecked: @escaping () -> Void) {
        self._titleInputString = State(initialValue: item.name)
        self.item = item
        self.toggleIsChecked = toggleIsChecked
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: item.isChecked ? "circle.inset.filled" : "circle")
                .onTapGesture {
                    toggleIsChecked()
                }
                .imageScale(.large)
            GeometryReader { geometry in
                HStack(spacing: 20) {
                    TextField("", text: $titleInputString)
                        .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 20))
                        .foregroundColor(Color(ColorKeys.appTextColor.rawValue))
                        .lineLimit(30)
                        
                    if item.quantity > 0 {
                        Text(String(item.quantity))
                            .font(.custom(FontKeys.Quicksand.bold.rawValue, size: 16))
                            .foregroundColor(Color(ColorKeys.appAccentTextColor.rawValue))
//                            .fixedSize()
                    }
                }
//                .frame(minWidth: 100, maxWidth: geometry.size.width)
                .fixedSize(horizontal: true, vertical: false)
            }
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
                        Text("")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
    }
}

struct ItemRow_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            ItemRow(item: ItemEntity.shortExampleItem) { }
            ItemRow(item: ItemEntity.mediumExampleItem) { }
            ItemRow(item: ItemEntity.longExampleItem) { }
        }
    }
}
