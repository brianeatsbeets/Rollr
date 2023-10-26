//
//  RollWindowDiceValues.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the currently selected dice and their values
struct RollWindowDiceValues: View {
    
    // MARK: - Properties
    
    // Binding
    
    @Binding var currentRoll: Roll
    
    // Basic
    
    let modifierOptions = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            ForEach($currentRoll.dice, id: \.id) { $die in
                
                // Individual die and values
                VStack {
                    
                    // Number of sides
                    NumberOfSidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollWindow)
                        .frame(maxHeight: .infinity)
                    
                    // Modifier
                    Menu {
                        Picker("Modifier", selection: $die.modifier) {
                            ForEach(modifierOptions, id: \.self) { value in
                                Text(value > 0 ? "+\(value)" : String(value))
                            }
                        }
                    } label: {
                        ModifierCircle(die: $die)
                            .scaleEffect(0.9)
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Roll value
                    Group {
                        RollValueShape(die: $die)
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Total (roll + modifier) value
                    Text(die.result > 0 ? die.total.description : "-")
                        .font(.title3.bold())
                        .minimumScaleFactor(0.5)
                        .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                
                // When a die's modifier changes...
                .onChange(of: die.modifier) { _ in
                    
                    // Remove the current preset name
                    currentRoll.presetName = ""
                    
                    // Reset the roll results
                    currentRoll.resetDiceResults()
                }
            }
        }
    }
}

//#Preview {
//    RollWindowDiceValues()
//}
