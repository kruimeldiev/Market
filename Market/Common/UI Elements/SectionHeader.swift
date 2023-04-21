//
//  SectionHeader.swift
//  Market
//
//  Created by Casper on 19/02/2023.
//

import SwiftUI

struct SectionHeader: View {
    
    private var section: SectionEntity
    private var didChangeSectionName: (String) -> Void
    private var toggleSectionIsCollapsed: () -> Void
    private var deleteSection: () -> Void
    private var addNewItemToSection: () -> Void
    
    @State var sectionTitle: String
    
    @FocusState var focusedField: FocusableField?
    
    init(section: SectionEntity,
         didChangeSectionName: @escaping (String) -> Void,
         toggleSectionIsCollapsed: @escaping () -> Void,
         deleteSection: @escaping () -> Void,
         addNewItemToSection: @escaping () -> Void) {
        self._sectionTitle = State(initialValue: section.name)
        self.section = section
        self.didChangeSectionName = didChangeSectionName
        self.toggleSectionIsCollapsed = toggleSectionIsCollapsed
        self.deleteSection = deleteSection
        self.addNewItemToSection = addNewItemToSection
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("", text: $sectionTitle)
                    .focused($focusedField, equals: .sectionTitle(id: section.id))
                    .keyboardType(.default)
                    .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 14))
                    .foregroundColor(Color(ColorKeys.accentText.rawValue))
                    .lineLimit(1)
                    .gesture(TapGesture().onEnded { _ in
                        /// This TapGesture is needed for selecting the TextField
                    })
                    .onChange(of: sectionTitle) { newValue in
                        didChangeSectionName(newValue)
                    }
                    .onSubmit {
                        addNewItemToSection()
                    }
                
                HStack(spacing: 20) {
                    Button {
                        toggleSectionIsCollapsed()
                    } label: {
                        Image(systemName: section.isCollapsed ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color(ColorKeys.defaultText.rawValue))
                    }
                    Button {
                        deleteSection()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color(ColorKeys.defaultText.rawValue))
                    }
                    Button {
                        addNewItemToSection()
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(Color(ColorKeys.defaultAccent.rawValue))
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if section.getAllItems().isEmpty {
                Rectangle()
                    .foregroundColor(Color(ColorKeys.defaultBackground.rawValue))
                    .frame(height: 60)
                    .onTapGesture {
                        addNewItemToSection()
                    }
            }
        }
        .padding(.vertical, 4)
    }
}

struct SectionHeader_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            
        }
//        ScrollView {
//            SectionHeader(section: SectionEntity.mediumExampleSection) { newValue in
//
//            } toggleSectionIsCollapsed: {
//
//            } deleteSection: {
//
//            } addNewItemToSection: {
//
//            }
//            SectionHeader(section: SectionEntity.mediumExampleSection) { newValue in
//
//            } toggleSectionIsCollapsed: {
//
//            } deleteSection: {
//
//            } addNewItemToSection: {
//
//            }
//            SectionHeader(section: SectionEntity.mediumExampleSection) { newValue in
//
//            } toggleSectionIsCollapsed: {
//
//            } deleteSection: {
//
//            } addNewItemToSection: {
//
//            }
//        }
    }
}
