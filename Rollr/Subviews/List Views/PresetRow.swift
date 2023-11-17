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
    var onScrollViewTap: (Roll) -> Void
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        VStack(alignment: .leading, spacing: 5) {
            
            // Name
            Text(preset.wrappedPresetName)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
            
            // Dice settings
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(preset.wrappedDice) { die in
                        VStack {
                            
                            // Number of sides
                            NumberOfSidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: Int(die.result))
                                .frame(height: 25)
                            
                            // Roll value + modifier
                            Text(die.modifierFormatted)
                                .font(.footnote)
                                .lineLimit(1)
                        }
                    }
                }
                //.contentShape(Rectangle())
            }
            
            // Perform action for selecting a preset when the scrollview is tapped
            .onTapGesture {
                onScrollViewTap(preset)
            }

            // Don't allow the view to scroll unless it the size of the content exceeds the size of the container
            .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        }
    }
}

//#Preview {
//    PresetRow()
//}
