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
    
    // Binding
    
    @Binding var rollAnimationIsActive: Bool
    
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
                    
                } label: {
                    NumberOfSidesHexagon(numberOfSides: sides.rawValue, type: .button)
                }
                .disabled(rollAnimationIsActive || currentRoll.dice.count >= 5)
            }
        }
    }
}

//#Preview {
//    DiceOptions()
//}
