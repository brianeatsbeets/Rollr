//
//  AdaptiveStack.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 11/1/23.
//  Adopted from https://www.hackingwithswift.com/quick-start/swiftui/how-to-automatically-switch-between-hstack-and-vstack-based-on-size-class
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that implements either a VStack or HStack depending on the current vertical size class
struct AdaptiveStack<Content: View>: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // Basic
    
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let switched: Bool
    let content: () -> Content
    
    // MARK: - Initializers

    init(horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, switched: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.switched = switched
        self.content = content
    }
    
    // MARK: - Body view

    var body: some View {
        Group {
            if verticalSizeClass == (switched ? .compact : .regular) {
                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
            }
        }
    }
}

//#Preview {
//    AdaptiveStack()
//}
