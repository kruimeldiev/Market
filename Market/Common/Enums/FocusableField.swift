//
//  FocusableField.swift
//  Market
//
//  Created by Casper on 21/04/2023.
//

import Foundation

enum FocusableField: Hashable {
    
    case sectionTitle(id: UUID)
    
    case itemTitle(id: UUID)
    case itemQuantity(id: UUID)
}
