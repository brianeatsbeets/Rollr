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
    
    // State
    
    @State var showingPresetNameAlert = false
    @State var newPresetName = ""
    @State var showingPresets = false
    
    // Binding
    
    @Binding var rolls: [Roll]
    @Binding var currentRoll: Roll
    @Binding var presets: [Roll]
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            
            // Presets button
            Menu {
                
                // Create a new preset
                Button("Save as preset") {
                    showingPresetNameAlert = true
                }
                .disabled(currentRoll.dice.isEmpty)
                
                // Load an existing preset
                Button("Load preset") {
                    showingPresets = true
                }
                .disabled(presets.isEmpty)
            } label: {
                Image(systemName: "list.dash")
                    .imageScale(.large)
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding([.bottom, .leading])
            
            Spacer()
            
            // Roll button
            Button {
                rollDice()
            } label: {
                Text(currentRoll.presetName.isEmpty ? "Roll" : currentRoll.presetName)
                    .font(.headline.leading(.tight))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(2)
                    .lineSpacing(-1)
                    .frame(height: 33)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.tint)
                    )
            }
            .disabled(currentRoll.dice.isEmpty)
            .padding(.bottom)
            
            Spacer()
            
            // Roll reset button
            Button {
                currentRoll = Roll()
            } label: {
                Text("Clear")
                    .font(.headline)
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .disabled(currentRoll.dice.isEmpty)
            .padding([.bottom, .trailing])
        }
        
        // New preset name alert with textfield
        .alert("Preset Name", isPresented: $showingPresetNameAlert) {
            TextField("Preset Name", text: $newPresetName)
            Button("OK", action: savePreset)
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Enter a name for this preset.")
        }
        
        // Existing presets list
        .sheet(isPresented: $showingPresets) {
            NavigationView {
                PresetsList(presets: $presets, currentRoll: $currentRoll) { selectedPreset in
                    
                    // Set the current roll to a new roll with the selected preset values
                    currentRoll = Roll(dice: selectedPreset.dice, presetName: selectedPreset.presetName)
                }
            }
        }
    }
    
    // Save a new dice preset
    func savePreset() {
        
        // Create a new preset and reset the dice results
        var newPreset = Roll(dice: currentRoll.dice)
        newPreset.resetDiceResults()
        
        // Prompt to enter a preset name
        showingPresetNameAlert = true
        
        // Set preset name
        newPreset.presetName = newPresetName
        
        // Reset the new preset name property to clear the text field when a new preset is created
        newPresetName = ""
        
        // Add the new preset to the presets list
        presets.append(newPreset)
        
        // Set the new preset as the current roll
        currentRoll = newPreset
    }
    
    // Determine a result for each die
    func rollDice() {
        
        // Create a new Roll and randomize the dice results
        var newRoll = Roll(dice: currentRoll.dice, presetName: currentRoll.presetName)
        newRoll.randomizeDiceResults()
        
        // Append the new roll to the rolls array
        rolls.append(newRoll)
        
        // Set the new role as the current roll
        currentRoll = newRoll
    }
}

//#Preview {
//    RollWindowButtons()
//}