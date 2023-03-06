//
//  SectionHeader.swift
//  Market
//
//  Created by Casper on 19/02/2023.
//

import SwiftUI

struct SectionHeader: View {
    
    private var section: SectionEntity
    private var didChangeSectionName: (String , String) -> Void
    private var toggleSectionIsCollapsed: () -> Void
    private var deleteSection: (String) -> Void
    private var addNewItemToSection: (String) -> Void
    
    @State var sectionTitle: String
    
    init(section: SectionEntity,
         didChangeSectionName: @escaping (String, String) -> Void,
         toggleSectionIsCollapsed: @escaping () -> Void,
         deleteSection: @escaping (String) -> Void,
         addNewItemToSection: @escaping (String) -> Void) {
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
                    .foregroundColor(Color(ColorKeys.appTextColor.rawValue))
                    .lineLimit(1)
                    .onChange(of: sectionTitle) { newValue in
                        didChangeSectionName(newValue, section.id.uuidString)
                    }
                Button {
                    addNewItemToSection(section.id.uuidString)
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                }
                Button {
                    deleteSection(section.id.uuidString)
                } label: {
                    Image(systemName: "xmark")
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
            SectionHeader(section: SectionEntity.mediumExampleSection) { newValue, sectionId in
                
            } toggleSectionIsCollapsed: {
                
            } deleteSection: { sectionId in
                
            } addNewItemToSection: { sectionId in
                
            }
        }
    }
}
