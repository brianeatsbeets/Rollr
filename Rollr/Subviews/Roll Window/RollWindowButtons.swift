//
//  RollWindowButtons.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the buttons to interact with the roll window
struct RollWindowButtons: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.managedObjectContext) var moc
    //@EnvironmentObject var currentRoll: LocalRoll
    //@EnvironmentObject var currentSession: Session
    @EnvironmentObject var currentRollViewModel: LocalRollViewModel
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // State
    
    @State private var showingPresetNameAlert = false
    @State private var newPresetName = ""
    @State private var showingPresets = false
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            
            // Save new preset button
            Button {
                showingPresetNameAlert = true
            } label: {
                Text("Save")
                    .font(.headline)
            }
            .disabled(currentRollViewModel.dice.isEmpty)
            .buttonStyle(BorderedButtonStyle())
            .padding(.leading)
            .disabled(animationStateManager.rollAnimationIsActive)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Roll button
            Button {
                Task {
                    await rollDice()
                }
                
                animationStateManager.orientationDidChange = false
            } label: {
                Text(currentRollViewModel.presetName.isEmpty ? "Roll" : currentRollViewModel.presetName)
                    .font(.headline.leading(.tight))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(2)
                    .lineSpacing(-1)
                    .frame(height: 33)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.tint)
                    )
            }
            .disabled(animationStateManager.rollAnimationIsActive || currentRollViewModel.dice.isEmpty)
            .frame(maxWidth: .infinity)
            
            // Clear button
            Button {
                withAnimation {
                    currentRollViewModel.resetRoll()
                }
                
                // Reset RollWindowDiceValues view offsets
                animationStateManager.diceValueOffsets.removeAll()
            } label: {
                Text("Clear")
                    .font(.headline)
            }
            .buttonStyle(BorderedButtonStyle())
            .disabled(animationStateManager.rollAnimationIsActive || currentRollViewModel.dice.isEmpty)
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom)
        
        // New preset name alert with textfield
        .alert("New Preset", isPresented: $showingPresetNameAlert) {
            TextField("Preset Name", text: $newPresetName)
            Button("OK", action: savePreset)
            Button("Cancel", role: .cancel, action: {
                newPresetName = ""
            })
        } message: {
            Text("Enter a name for this preset.")
        }
    }
    
    // Save a new dice preset
    func savePreset() {
        
        // Create a new preset and reset the dice results
        let newPreset = Roll(context: moc)
        newPreset.dateRolled = Date.now
        newPreset.isPreset = true
        newPreset.wrappedDice = currentRollViewModel.dieEntityDice(context: moc)
        newPreset.resetDiceResults()

        // Prompt to enter a preset name
        showingPresetNameAlert = true
        
        // Set preset name
        newPreset.presetName = newPresetName
        
        // Reset the new preset name property to clear the text field when a new preset is created
        newPresetName = ""
        
        // Add the new preset to the presets list
        if moc.hasChanges {
            try? moc.save()
        }
        
        // Set the new preset as the current roll
        currentRollViewModel.adoptRoll(rollEntity: newPreset)
        currentRollViewModel.setPresetId(newPresetId: newPreset.objectID.description)
    }
    
    // Determine a result for each die
    func rollDice() async {
        
        // Animate pre-roll
        await playRollingAnimation()
        
        // Create a new Roll and randomize the dice results
        let newRoll = Roll(context: moc)
        newRoll.dateRolled = Date.now
        newRoll.isPreset = false
        newRoll.wrappedDice = currentRollViewModel.dieEntityDice(context: moc)
        newRoll.presetName = currentRollViewModel.presetName
        newRoll.randomizeDiceResults()
        
        // Set the roll's session as the current session
        newRoll.session = dataController.currentSession
        
        // Append the new roll to the rolls array
        if moc.hasChanges {
            try? moc.save()
        }
        
        // Set the new role as the current roll
        currentRollViewModel.adoptRoll(rollEntity: newRoll)
    }
    
    // Animate the roll results before presenting the final results
    func playRollingAnimation() async {
        
        // Set animation state to true
        animationStateManager.rollAnimationIsActive = true
        
        // Set initial increment value
        var increment: Double = 20_000_000
        
        // Randomize dice results, and then wait the increment time period
        while increment < 160_000_000 {
            increment = increment * 1.18
            currentRollViewModel.randomizeDiceResults(animating: true)
            try? await Task.sleep(nanoseconds: UInt64(increment))
        }
        
        // Set animation state to false
        animationStateManager.rollAnimationIsActive = false
    }
}

//#Preview {
//    RollWindowButtons()
//}
