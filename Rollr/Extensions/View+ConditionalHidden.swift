//
//  View+ConditionalHidden.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/25/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Extensions

// This extension creates a custom hidden modifier
extension View {
    
    // Conditionally hide the view
    func conditionalHidden(_ hidden: Bool) -> some View {
        modifier(ConditionalHidden(hidden: hidden))
    }
}

// MARK: - Structs

// This struct provides a custom view modifier that hides the view based on the provided boolean value
struct ConditionalHidden: ViewModifier {
    
    // Properties
    
    var hidden: Bool
    
    // Main body
    
    func body(content: Content) -> some View {
        
        if hidden {
            content
                .hidden()
        } else {
            content
        }
    }
}
