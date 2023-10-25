//
//  RollWindow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollWindow: View {
    
    // Environment
    @Environment(\.colorScheme) var theme
    //@Environment(\.modelContext) var modelContext
    
    @State private var showingModifierView = false
    @State private var dieBeingModified: Die?
    @State private var showingPresets = false
    @State private var showingPresetNameAlert = false
    @State private var newPresetName = ""
    
    // Binding
    @Binding var rolls: [Roll]
    @Binding var presets: [Roll]
    @Binding var currentRoll: Roll
    
    let modifierOptions = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    
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
                            
                        // Dice and values
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
                                
                                // Dice
                                HStack {
                                    ForEach($currentRoll.dice, id: \.id) { $die in
                                        
                                        VStack {
                                            
                                            // Number of sides
                                            SidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollWindow)
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
                                            
                                            // Total value
                                            Text(die.result > 0 ? die.total.description : "-")
                                                .font(.title3.bold())
                                                .minimumScaleFactor(0.5)
                                                .frame(maxHeight: .infinity)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .onChange(of: die.modifier) { _ in
                                            
                                            // Remove the current preset name
                                            currentRoll.presetName = ""
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
                                Text(currentRoll.grandTotal != 0 ? currentRoll.grandTotal.description : "-")
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
                            Button("Save as preset") {
                                showingPresetNameAlert = true
                            }
                            .disabled(currentRoll.dice.isEmpty)
                            
                            Button("Load preset") {
                                showingPresets = true
                            }
                            .disabled(presets.isEmpty)
                        } label: {
                            Image(systemName: "list.dash")
                                .imageScale(.large)
                        }
                        .padding([.bottom, .leading])
                        
                        Spacer()
                        
                        // Roll button
                        Button {
                            rollDice()
                        } label: {
                            Text("Roll")
                                .font(.headline)
                                .padding(.horizontal, 20)
                        }
                        .disabled(currentRoll.dice.isEmpty)
                        .padding(.bottom)
                        
                        Spacer()
                        
                        // Roll reset button
                        Button {
                            currentRoll.dice.removeAll()
                        } label: {
                            Text("Clear")
                                .font(.headline)
                        }
                        .disabled(currentRoll.dice.isEmpty)
                        .padding([.bottom, .trailing])
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                .alert("Preset Name", isPresented: $showingPresetNameAlert) {
                    TextField("Preset Name", text: $newPresetName)
                    Button("OK", action: savePreset)
                    Button("Cancel", role: .cancel, action: {})
                } message: {
                    Text("Enter a name for this preset.")
                }
                .sheet(isPresented: $showingPresets) {
                    NavigationView {
                        PresetsView(presets: $presets) { selectedPreset in
                            
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
        rolls.append(currentRoll)
        
        // Set the new role as the current roll
        currentRoll = newRoll
    }
}

//#Preview {
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
