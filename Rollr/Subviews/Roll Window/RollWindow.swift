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
    @Binding var presets: [RollSettings]
    @Binding var currentRollSettings: RollSettings
    @Binding var latestRoll: Roll?
    
    let modifierOptions = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    
    var body: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(theme == .light ? Color.white : Color(uiColor: .secondarySystemBackground))
            
            // Roll window content
            VStack {
                
                // Awaiting roll text
                if currentRollSettings.dice.isEmpty {
                    VStack {
                        Spacer()
                        
                        Text("Choose your dice!")
                            .font(.title)
                        
                        Spacer()
                    }
                } else {
                    
                    // Dice and values
                    VStack {
                        HStack {
                            
                            // Row labels
                            if !currentRollSettings.dice.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Dice:")
                                        .frame(height: 40)
                                    
                                    Text("Modifier:")
                                        .frame(height: 40)
                                    
                                    Text("Roll:")
                                        .frame(height: 40)
                                    
                                    Text("Total:")
                                        .bold()
                                        .frame(height: 40)
                                }
                                .font(.title3.weight(.medium))
                                .padding(.leading, 10)
                                .layoutPriority(1)
                            }
                            
                            Spacer()
                            
                            ForEach($currentRollSettings.dice, id: \.id) { $die in
                                
                                Spacer()
                                
                                VStack {
                                    
                                    // Number of sides
                                    SidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollWindow)
                                        .frame(height: 40)
                                    
                                    // Modifier
                                    Menu {
                                        Picker("Modifier", selection: $die.modifier) {
                                            ForEach(modifierOptions, id: \.self) { value in
                                                Text(value > 0 ? "+\(value)" : String(value))
                                            }
                                        }
                                    } label: {
                                        ModifierCircle(die: $die)
                                            .frame(height: 30)
                                    }
                                    .frame(height: 40)
                                    
                                    // Roll value
                                    Group {
                                        RollValueShape(die: $die)
                                            .frame(height: 35)
                                    }
                                    .frame(height: 40)
                                    
                                    // Total value
                                    Text(die.result > 0 ? die.total.description : "-")
                                        .font(.title2.bold())
                                        .minimumScaleFactor(0.5)
                                        .frame(height: 40)
                                }
                                .onChange(of: die.modifier) { _ in
                                    
                                    // Re-create the die (regenerating the id). This avoids triggering an edge case where loading a preset, changing the modifier, and then loading the same preset again would re-trigger the .onChange, resulting in a different RollSettings than the selected preset being loaded. This results in a preset name not being recorded in the roll history when it should be.
                                    let newDie = Die(numberOfSides: die.numberOfSides, modifier: die.modifier)
                                    die = newDie
                                    
                                    // Re-create the roll settings with the new die
                                    let newRollSettings = RollSettings(dice: currentRollSettings.dice)
                                    currentRollSettings = newRollSettings
                                }
                                
                                Spacer()
                            }
                        }
                        .padding([.top, .trailing], 10)
                        .background(.yellow.opacity(0.4))
                        
                        Spacer()
                            .background(.red.opacity(0.4))
                    }
                }
                
                // Bottom row buttons
                HStack {
                    
                    // Presets button
                    Menu {
                        Button("Save as preset") {
                            showingPresetNameAlert = true
                        }
                        .disabled(currentRollSettings.dice.isEmpty)
                        
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
                        Text("Roll")
                            .font(.headline)
                            .padding(.horizontal, 20)
                    }
                    .disabled(currentRollSettings.dice.isEmpty)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.bottom)
                    
                    Spacer()
                    
                    // Roll reset button
                    Button {
                        currentRollSettings.dice.removeAll()
                    } label: {
                        Text("Clear")
                            .font(.headline)
                    }
                    .disabled(currentRollSettings.dice.isEmpty)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding([.bottom, .trailing])
                }
                .background(.red.opacity(0.4))
            }
            .background(.green.opacity(0.4))
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
                    currentRollSettings = selectedPreset
                }
            }
        }
    }
    
    // Save a new dice preset
    func savePreset() {
        
        // Prompt to enter a preset name
        showingPresetNameAlert = true
        
        // Clone the current dice without the result (each die will have a new id)
        var presetDice = [Die]()
        for die in currentRollSettings.dice {
            presetDice.append(Die(numberOfSides: die.numberOfSides, modifier: die.modifier))
        }
        
        // Create a new preset with the new dice
        let newPreset = RollSettings(name: newPresetName, dice: presetDice)
        
        // Add the new preset to the presets list
        presets.append(newPreset)
        
        // Set the new preset as the current roll settings
        currentRollSettings = newPreset
        
        // Reset the new preset name property to clear the text field when a new preset is created
        newPresetName = ""
    }
    
    // Determine a result for each die
    func rollDice() {
        currentRollSettings.dice.indices.forEach {
            currentRollSettings.dice[$0].result = Int.random(in: 1...currentRollSettings.dice[$0].numberOfSides.rawValue)
        }
        
        latestRoll = Roll(rollSettings: RollSettings(name: currentRollSettings.name, dice: currentRollSettings.dice))
        rolls.append(latestRoll!)
    }
}

//#Preview {
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
