//
//  ItemRow.swift
//  Market
//
//  Created by Casper on 16/01/2023.
//

import SwiftUI
import CoreData

struct ItemRow: View {
    
    var item: ItemEntity
    var toggleIsChecked: () -> Void
    
    @State private var titleInputString = ""
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: item.isChecked ? "circle.inset.filled" : "circle")
                .onTapGesture {
                    toggleIsChecked()
                }
                .imageScale(.large)
            HStack(spacing: 20) {
                if item.title == nil {
                    TextField("", text: $titleInputString)
                        .focused($focusedField, equals: .titleField)
                        .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 20))
                        .foregroundColor(Color(ColorKeys.appTextColor.rawValue))
                } else {
                    Text(item.title ?? "")
                        .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 20))
                        .foregroundColor(Color(ColorKeys.appTextColor.rawValue))
                }
                if item.quantity > 0 {
                    Text(String(item.quantity))
                        .font(.custom(FontKeys.Quicksand.bold.rawValue, size: 18))
                        .foregroundColor(Color(ColorKeys.appAccentTextColor.rawValue))
                }
            }
            Spacer()
            Group {
                switch item.priority {
                    case 1:
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 14)
                    case 2:
                        Circle()
                            .foregroundColor(.orange)
                            .frame(width: 14)
                    case 3:
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 14)
                    default:
                        Text("")
                }
            }
        }
        .onAppear {
            self.focusedField = .titleField
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    
    static var previews: some View {
        let item = ItemEntity.emptyExampleItem
        ItemRow(item: item) { }
    }
}
