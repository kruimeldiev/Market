//
//  FocusFields.swift
//  Market
//
//  Created by Casper on 22/01/2023.
//

import Foundation

enum FocusField: Hashable {
    
    case sectionTitleField(id: String)
    
    case itemTitleField(id: String)
    case itemNoteField(id: String)
}
