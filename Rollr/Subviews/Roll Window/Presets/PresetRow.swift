//
//  PresetRow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a roll preset row
struct PresetRow: View {
    
    // MARK: - Properties
    
    let preset: Roll
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            
            // Name
            Text(preset.presetName)
                .font(.title2.weight(.semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.3)
            
            Spacer()
            
            // Dice settings
            ForEach(preset.dice) { die in
                HStack(spacing: 0) {
                    VStack {
                        
                        // Number of sides
                        NumberOfSidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: die.result)
                            .frame(height: 25)
                        
                        // Roll value + modifier
                        Text(die.modifierFormatted)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}

//#Preview {
//    PresetRow()
//}
