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
    
    // Environment
    
    @EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // Basic
    
    let modifierOptions = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            ForEach($currentRoll.dice, id: \.id) { $die in
                
                // Store die index for animation parameters
                let dieIndex = currentRoll.dice.firstIndex(where: { $0.id == die.id })
                
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
                        
                        // Display as text view if we're animating the roll OR the result was not a min/max value
                        if animationStateManager.rollAnimationIsActive || (!animationStateManager.rollAnimationIsActive && (die.result != 1 && die.result != die.numberOfSides.rawValue)) {
                            Text(die.result > 0 ? die.result.description : "-")
                                .font(.title3)
                        } else {
                            RollValueShape(die: $die)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Total (roll + modifier) value
                    Text(animationStateManager.rollAnimationIsActive ? "-" : (die.result > 0 ? die.total.description : "-"))
                        .font(.title3.bold())
                        .minimumScaleFactor(0.5)
                        .scaleEffect(animationStateManager.rollResultsScale)
                        .frame(maxHeight: .infinity)
                        .onChange(of: animationStateManager.rollAnimationIsActive) { newValue in
                            
                            // Only animate after roll animation has finished
                            if newValue == false {
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        animationStateManager.rollResultsScale = 1.2
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.easeOut(duration: 0.1)) {
                                        animationStateManager.rollResultsScale = 1.0
                                    }
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .offset(y: animationStateManager.diceValueOffsets[dieIndex ?? 0])
                
                // Animate appearing from above
                .animation(.easeOut(duration: 0.2), value: animationStateManager.diceValueOffsets)
                .onAppear {
                    animationStateManager.diceValueOffsets[dieIndex ?? 0] = 0
                }
                
                // When a die's modifier changes...
                .onChange(of: die.modifier) { _ in
                    
                    // Remove the current preset name
                    currentRoll.presetName = ""
                    
                    // Reset the roll results
                    currentRoll.resetDiceResults()
                }
            }
        }
        
        // Animate when the current dice are updated
        .animation(.default, value: currentRoll.dice.count)
    }
}

//#Preview {
//    RollWindowDiceValues()
//}
