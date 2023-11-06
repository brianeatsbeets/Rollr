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
    
    // Environment
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            ForEach(NumberOfSides.allCases, id: \.self) { sides in
                
                // Individual die option
                Button {
                    
                    // Append the selected die to the dice array
                    let newDie = LocalDie(numberOfSides: sides)
                    
                    // Animate adding new die
                    currentRoll.dice.append(newDie)
                    
                    // Reset the roll id and preset name
                    currentRoll.id = UUID()
                    currentRoll.presetName = ""
                    
                    // Add a die value offset for animating die creation
                    animationStateManager.diceValueOffsets.append(-150)
                    
                } label: {
                    NumberOfSidesHexagon(numberOfSides: sides.rawValue, type: .button)
                }
            }
        }
    }
}

//#Preview {
//    DiceOptions()
//}
