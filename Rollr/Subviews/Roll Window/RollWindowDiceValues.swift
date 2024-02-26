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
    
    //@EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var currentRollViewModel: LocalRollViewModel
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // State
    
    @State private var showingModifierSelector = false
    @State private var selectedDie: LocalDie?
    @State private var selectedDieIndex = 0
    
    // Basic
    
    let modifierOptions = Array(-20...20)
    
    // MARK: - Body view
    
    var body: some View {
        
        ScrollViewReader { value in
            ScrollView(.horizontal) {
                
                // Main stack
                HStack(spacing: 0) {
                    ForEach(currentRollViewModel.dice) { die in
                        
                        // Store die index for animation parameters
                        let dieIndex = currentRollViewModel.dice.firstIndex(where: { $0.id == die.id })
                        
                        // Individual die and values
                        VStack {
                            
                            // Number of sides
                            NumberOfSidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollWindow)
                                .frame(maxHeight: .infinity)
                            
                            // Modifier - Button that displays sheet
                            Button {
                                selectedDie = die
                                selectedDieIndex = dieIndex ?? 0
                            } label: {
                                ModifierCircle(die: die)
                                    .scaleEffect(0.9)
                            }
                            
                            // Roll value
                            Group {
                                
                                // Display as text view if we're animating the roll OR the result was not a min/max value
                                if animationStateManager.rollAnimationIsActive || (!animationStateManager.rollAnimationIsActive && (die.result != 1 && die.result != die.numberOfSides.rawValue)) {
                                    Text(die.result > 0 ? die.result.description : "-")
                                        .font(.title3)
                                        .onAppear {
                                            print(die.result)
                                        }
                                } else {
                                    RollValueShape(die: die)
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
                                        
                                        animationStateManager.rollResultsScale = 0.1
                                        
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
                        .frame(width: 50)
                        .offset(y: animationStateManager.diceValueOffsets[dieIndex ?? 0])
                        
                        // Animate appearing from above
                        .animation(.easeOut(duration: 0.2), value: animationStateManager.diceValueOffsets)
                        .onAppear {
                            animationStateManager.diceValueOffsets[dieIndex ?? 0] = 0
                        }
                        
                        // When a die's modifier changes...
                        .onChange(of: die.modifier) { _ in
                            
                            // Remove the current preset name
                            currentRollViewModel.setPresetName(newPresetName: "")
                            
                            // Reset the roll results
                            currentRollViewModel.resetDiceResults()
                        }
                        
                        .id(dieIndex)
                        .onChange(of: currentRollViewModel.dice.count) { _ in
                            
                            // When a new die is added, scroll to it
                            withAnimation {
                                value.scrollTo(currentRollViewModel.dice.count - 1)
                            }
                        }
                    }
                }
                .padding(.leading, 5)
                
                // Animate when the current dice are updated
                .animation(.default, value: currentRollViewModel.dice.count)
            }
            
            // Don't allow the view to scroll unless it the size of the content exceeds the size of the container
            .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        }
        
        // Present EditDieModifier view
        .sheet(item: $selectedDie) { die in
            EditDieModifier(dieIndex: selectedDieIndex) { newValue in
                currentRollViewModel.setDieModifier(index: selectedDieIndex, newVlaue: newValue)
            }
            .presentationDetents([.height(150)])
        }
        
    }
}

//#Preview {
//    RollWindowDiceValues()
//}
