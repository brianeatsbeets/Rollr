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
            .title2
            .weight(.heavy)
        case .small:
            .callout
            .weight(.heavy)
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
    var singleHexagonTextWidth: CGFloat {
        switch scale {
        case .regular:
            35
        case .small:
            23
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
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(.white)
                    .frame(width: singleHexagonTextWidth)
            }
        }
    }
}

enum RollSettingsValuesScale {
    case regular, small
}

#Preview {
    RollSettingsValues(numberOfDice: .constant(3), numberOfSides: .constant(100), scale: .regular)
}
