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
    
    // Binding
    
    @Binding var currentRoll: LocalRoll
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            ForEach(NumberOfSides.allCases, id: \.self) { sides in
                
                // Individual die option
                Button {
                    
                    // Append the selected die to the dice array
                    let newDie = Die(context: moc)
                    newDie.numberOfSides = sides
                    //currentRoll.wrappedDice.append(newDie)
                    currentRoll.dice.append(LocalDie(dieEntity: newDie))
                    
                    // Reset each die result
//                    currentRoll.dice.indices.forEach {
//                        currentRoll.dice[$0].result = 0
//                    }
                    currentRoll.resetDiceResults()
                    
                    // Re-create the roll settings with the existing die
                    let newRoll = Roll(context: moc)
                    newRoll.wrappedDice = currentRoll.dieEntityDice(context: moc)
                    currentRoll = LocalRoll(rollEntity: newRoll)
                    
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
