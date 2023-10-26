//
//  DiceOptions.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of die buttons representing the possible number of sides
struct DiceOptions: View {
    
    // MARK: - Properties
    
    // Binding
    
    @Binding var currentRoll: Roll
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            ForEach(NumberOfSides.allCases, id: \.self) { sides in
                
                // Individual die option
                Button {
                    
                    // Append the selected die to the dice array
                    currentRoll.dice.append(Die(numberOfSides: sides))
                    
                    // Reset each die result
                    currentRoll.dice.indices.forEach {
                        currentRoll.dice[$0].result = 0
                    }
                    
                    // Re-create the roll settings with the existing die
                    let newDice = currentRoll.dice
                    currentRoll = Roll(dice: newDice)
                    
                } label: {
                    NumberOfSidesHexagon(numberOfSides: sides.rawValue, type: .button)
                }
                .disabled(currentRoll.dice.count >= 5)
            }
        }
    }
}

//#Preview {
//    DiceOptions()
//}
