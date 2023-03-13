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
                    .font(.custom(FontKeys.Quicksand.medium.rawValue, size: 14))
                    .foregroundColor(Color(ColorKeys.accentText.rawValue))
                    .lineLimit(1)
                    .gesture(TapGesture().onEnded { _ in })
                    .onChange(of: sectionTitle) { newValue in
                        didChangeSectionName(newValue)
                    }
                    .onSubmit {
                        addNewItemToSection()
                    }
                
                if section.name != "" {
                    Button {
                        deleteSection()
                    } label: {
                        Image(systemName: "info")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.vertical, 4)
    }
}

struct SectionHeader_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView {
            SectionHeader(section: SectionEntity.mediumExampleSection) { newValue in
                
            } toggleSectionIsCollapsed: {
                
            } deleteSection: {
                
            } addNewItemToSection: {
                
            }
        }
    }
}
