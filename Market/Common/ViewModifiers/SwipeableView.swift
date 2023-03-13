//
//  SwipeableView.swift
//  Market
//
//  Created by Casper on 08/03/2023.
//

import SwiftUI

/// SwiftUI only supports swipe functionality on UI elements that are embedded in Lists
/// This ViewModifier adds that functionality (and makes it customizable) for any other View
struct SwipeableView: ViewModifier {
    
    @State private var rowOffsetX: CGFloat = 0
    @State private var contextMenuIsShowing: Bool = false
    @State private var impactFeedbackCalled = false
    
    private var callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    func body(content: Content) -> some View {
        ZStack {
            
            Color(ColorKeys.errorRed.rawValue)
            
            HStack {
                Spacer()
                Button {
                    withAnimation { callback() }
                } label: {
                    Image(systemName: "trash")
                        .font(.body)
                        .foregroundColor(Color(ColorKeys.defaultBackground.rawValue))
                        .frame(width: 60)
                        .offset(x: rowOffsetX + 60)
                }
            }
            
            // MARK: - Content
            content
                .offset(x: rowOffsetX)
                .gesture(DragGesture()
                    .onChanged { value in
                        onSwipeChanged(value: value)
                    }.onEnded { value in
                        onSwipeEnded(value: value)
                    }
                )
        }
    }
    
    func onSwipeChanged(value: DragGesture.Value) {
        if value.translation.width < 0 {
            /// If swipe to left
            if -value.translation.width > UIScreen.main.bounds.width / 2,
                !impactFeedbackCalled {
                /// If swiped more than half the screen, apply some haptic feedback for the user
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                impactFeedbackCalled = true
            } else if contextMenuIsShowing {
                /// If the context menu is showing and the user starts swioing the View again, we have to make sure that the offset stays consistant
                rowOffsetX = value.translation.width - 60
            } else {
                rowOffsetX = value.translation.width
            }
        } else if value.translation.width >= 0
                    && value.translation.width <= 60
                    && contextMenuIsShowing {
            /// If the context menu is showing and the user swipes back, this block makes the menu dissappear
            rowOffsetX = value.translation.width - 60
        }
    }

    func onSwipeEnded(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    /// If swiped more than half the screen, the context function should be called
                    rowOffsetX = -1000
                    callback()
                } else if -rowOffsetX > 70 {
                    /// Show the context menu
                    contextMenuIsShowing = true
                    impactFeedbackCalled = false
                    rowOffsetX = -60
                } else {
                    /// Hide the context menu
                    contextMenuIsShowing = false
                    rowOffsetX = 0
                }
            } else {
                contextMenuIsShowing = false
                impactFeedbackCalled = false
                rowOffsetX = 0
            }
        }
    }
}
