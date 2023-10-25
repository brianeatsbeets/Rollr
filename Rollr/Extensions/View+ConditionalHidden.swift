//
//  View+ConditionalHidden.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/25/23.
//

import SwiftUI

extension View {
    func conditionalHidden(_ hidden: Bool) -> some View {
        //opacity(hidden ? 0 : 1)
        modifier(ConditionalHidden(hidden: hidden))
    }
}

struct ConditionalHidden: ViewModifier {
    var hidden: Bool
    
    func body(content: Content) -> some View {
        
        if hidden {
            content
                .hidden()
        } else {
            content
        }
    }
}
