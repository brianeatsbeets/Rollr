//
//  RollWindow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the current roll information
struct RollWindow: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    //@Environment(\.modelContext) var modelContext
    
    // State
    
    @State private var showingModifierView = false
    @State private var dieBeingModified: Die?
    @State private var showingPresets = false
    @State private var showingPresetNameAlert = false
    @State private var newPresetName = ""
    
    // Binding
    
    @Binding var rolls: [Roll]
    @Binding var presets: [Roll]
    @Binding var currentRoll: Roll
    
    // Basic
    
    let modifierOptions = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    
    // MARK: - Body view
    
    var body: some View {
            
        // Background
        RoundedRectangle(cornerRadius: 10)
            .fill(theme == .light ? Color.white : Color(uiColor: .secondarySystemBackground))
            .overlay(
        
                // Roll window content
                VStack {
                    ZStack {
                        
                        // Awaiting roll text
                        VStack {
                            Spacer()
                            
                            Text("Choose your dice!")
                                .font(.title)
                            
                            Spacer()
                        }
                        .conditionalHidden(!currentRoll.dice.isEmpty)
                            
                        // Dice info and labels
                        VStack {
                            HStack {
                                
                                // Row labels
                                if !currentRoll.dice.isEmpty {
                                    VStack(alignment: .leading) {
                                        Text("Dice:")
                                            .frame(maxHeight: .infinity)
                                        
                                        Text("Modifier:")
                                            .frame(maxHeight: .infinity)
                                        
                                        Text("Roll:")
                                            .frame(maxHeight: .infinity)
                                        
                                        Text("Total:")
                                            .bold()
                                            .frame(maxHeight: .infinity)
                                    }
                                    .font(.title3.weight(.medium))
                                    .padding(.leading, 10)
                                    .layoutPriority(1)
                                }
                                
                                Spacer()
                                
                                // Dice and values
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
                            
                                Spacer()
                            }
                            .padding([.top, .trailing], 10)
                            
                            // Grand total
                            HStack {
                                
                                // Label
                                Text("Grand total:")
                                    .font(.title3.weight(.medium))
                                    .padding(.leading, 10)
                                
                                // Value
                                Text(currentRoll.rollTotal != 0 ? currentRoll.grandTotal.description : "-")
                                    .font(.title2.bold())
                                    .minimumScaleFactor(0.5)
                            }
                        }
                        .conditionalHidden(currentRoll.dice.isEmpty)
                    }
                    
                    Spacer()
                    
                    // Bottom row buttons
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
                        PresetsView(presets: $presets, currentRoll: $currentRoll) { selectedPreset in
                            
                            // Set the current roll to a new roll with the selected preset values
                            currentRoll = Roll(dice: selectedPreset.dice, presetName: selectedPreset.presetName)
                        }
                    }
                }
            )
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
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
