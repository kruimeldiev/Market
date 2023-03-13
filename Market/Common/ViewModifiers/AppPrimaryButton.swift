//
//  AppPrimaryButton.swift
//  Market
//
//  Created by Casper on 13/03/2023.
//

import SwiftUI

struct AppPrimaryButton: ViewModifier {

    let width: CGFloat
    let height: CGFloat
    let backgroundColor: Color
    let iconName: String

    func body(content: Content) -> some View {
        ZStack {
            content
                .font(.headline)
                .frame(width: width, height: height)
                .background(backgroundColor)
                .cornerRadius(width / 4)
            Image(systemName: iconName)
                .foregroundColor(.white)
        }
    }
}

struct BaseProjectSecondaryButton: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.black)
    }
}

