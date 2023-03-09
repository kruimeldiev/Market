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
            HStack(spacing: 6) {
                Image(section.iconName ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                TextField("", text: $sectionTitle)
                    .font(.custom(FontKeys.Quicksand.bold.rawValue, size: 20))
                    .foregroundColor(Color(ColorKeys.defaultText.rawValue))
                    .lineLimit(1)
                    .onChange(of: sectionTitle) { newValue in
                        didChangeSectionName(newValue)
                    }
                Button {
                    addNewItemToSection()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
                Spacer(minLength: 20)
                Button {
                    deleteSection()
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(20)
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
