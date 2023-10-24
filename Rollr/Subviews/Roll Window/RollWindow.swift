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
    @State private var selectedModifier = 0
    @State private var showingResults = false
    @State private var showingPresets = false
    @State private var showingPresetNameAlert = false
    @State private var newPresetName = ""
    
    // Binding
    @Binding var rolls: [Roll]
    @Binding var presets: [RollSettings]
    @Binding var dice: [Die]
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
                if dice.isEmpty {
                    VStack {
                        Spacer()
                        Spacer()
                        
                        Text("Choose your dice!")
                            .font(.title)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                } else {
                    
                    // Dice and values
                    VStack {
                        HStack {
                            
                            // Row labels
                            if !dice.isEmpty {
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
                            
                            ForEach($dice, id: \.id) { $die in
                                
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
                                        RollValueShape(showingResults: $showingResults, die: $die)
                                            .frame(height: 35)
                                    }
                                    .frame(height: 40)
                                    
                                    // Total value
                                    Text(showingResults ? die.total.description : "-")
                                        .font(.title2.bold())
                                        .minimumScaleFactor(0.5)
                                        .frame(height: 40)
                                }
                                .onChange(of: die.modifier) { _ in
                                    showingResults = false
                                }
                                
                                Spacer()
                            }
                        }
                        .padding([.top, .trailing], 10)
                        
                        Spacer()
                    }
                }
                
                // Roll + reset buttons
                ZStack {
                    
                    // Roll button
                    Button {
                        rollDice()
                        showingResults = true
                    } label: {
                        Text("Roll")
                            .font(.headline)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 5)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.tint)
                            )
                    }
                    .padding(.bottom)
                    .disabled(dice.isEmpty)
                    
                    HStack {
                        
                        // Presets button
                        Menu("Presets") {
                            Button("Save as preset") {
                                showingPresetNameAlert = true
                                print(showingPresetNameAlert)
                            }
                            .disabled(dice.isEmpty)

                            Button("Load preset") {
                                showingPresets = true
                            }
                        }
                        .padding([.bottom, .leading], 15)
                        
                        Spacer()
                        
                        // Roll reset button
                        Button(role: .destructive) {
                            dice.removeAll()
                        } label: {
                            Image(systemName: "trash")
                                .imageScale(.large)
                                .fontWeight(.semibold)
                        }
                        .padding([.bottom, .trailing], 15)
                    }
                }
            }
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
                    dice = selectedPreset.dice
                    showingResults = false
                }
            }
        }
    }
    
    // Save a new dice preset
    func savePreset() {
        
        showingPresetNameAlert = true
        
        // Replicate the current dice settings and reset the result
        var presetDice = dice
        presetDice.indices.forEach {
            presetDice[$0].result = 0
        }
        
        presets.append(RollSettings(name: newPresetName, dice: presetDice))
        
        newPresetName = ""
    }
    
    // Determine a result for each die
    func rollDice() {
        dice.indices.forEach {
            dice[$0].result = Int.random(in: 1...dice[$0].numberOfSides.rawValue)
        }
        
        latestRoll = Roll(rollSettings: RollSettings(dice: dice))
        rolls.append(latestRoll!)
    }
}

//#Preview {
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
