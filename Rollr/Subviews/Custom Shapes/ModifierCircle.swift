//
//  ModifierCircle.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/23/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the modifier value of a given die
struct ModifierCircle: View {
    
    // MARK: - Properties
    
    // Binding
    
    @Binding var die: Die
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main shape
        Circle()
            .fill(.tint)
            .overlay(
                GeometryReader { geo in
                    
                    // Modifier value
                    Text(die.modifierFormatted)
                        .font(.system(size: min(geo.size.height, geo.size.width) * 0.6))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                }
            )
    }
}

#Preview {
    HStack {
        ModifierCircle(die: .constant(Die(numberOfSides: .six)))
    }
}
