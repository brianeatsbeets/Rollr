//
//  ModifierCircle.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/23/23.
//

import SwiftUI

struct ModifierCircle: View {
    
    @Binding var die: Die
    
    var body: some View {
        Circle()
            .fill(.tint)
            .overlay(
                GeometryReader { geo in
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
