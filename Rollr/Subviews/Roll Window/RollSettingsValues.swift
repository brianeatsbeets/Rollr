//
//  RollSettingsValues.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollSettingsValues: View {
    
    @Binding var numberOfDice: Int
    @Binding var numberOfSides: Int
    let scale: RollSettingsValuesScale
    
    var multiHexagonSize: CGFloat {
        switch scale {
        case .regular:
            24
        case .small:
            15
        }
    }
    var scaledFont: Font {
        switch scale {
        case .regular:
            .title3.weight(.semibold)
        case .small:
            .caption2.bold()
        }
    }
    var singleHexagonSize: CGFloat {
        switch scale {
        case .regular:
            40
        case .small:
            26
        }
    }
    
    var body: some View {
        HStack {
            
            // Number of dice
            ZStack {
                MultiHexagon(size: multiHexagonSize)
                Text(numberOfDice, format: .number)
                    .font(scaledFont)
                    .foregroundStyle(.white)
            }
            
            // Number of sides
            ZStack {
                Image(systemName: "hexagon.fill")
                    .font(.system(size: singleHexagonSize))
                Text(numberOfSides, format: .number)
                    .font(scaledFont)
                    .foregroundStyle(.white)
            }
        }
    }
}

enum RollSettingsValuesScale {
    case regular, small
}

#Preview {
    RollSettingsValues(numberOfDice: .constant(3), numberOfSides: .constant(6), scale: .regular)
}
