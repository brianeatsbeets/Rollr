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
    @EnvironmentObject var currentRoll: LocalRoll
    
    // Fetch request
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.presetName)], predicate: NSPredicate(format: "isPreset = %d", true)) var presets: FetchedResults<Roll>
    
    // State
    
    @State private var showingPresetNameAlert = false
    @State private var newPresetName = ""
    @State private var showingPresets = false
    
    // Binding
    
    @Binding var rollIsAnimating: Bool
    
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
                Task {
                    await rollDice()
                }
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
            .disabled(rollIsAnimating || currentRoll.dice.isEmpty)
            .padding(.bottom)
            
            Spacer()
            
            // Roll reset button
            Button {
                currentRoll.reset()
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
                PresetsList(presets: presets) { selectedPreset in
                    
                    // Set the current roll to a new roll with the selected preset values
                    currentRoll.adoptRoll(rollEntity: selectedPreset)
                }
            }
        }
    }
    
    // Save a new dice preset
    func savePreset() {
        
        // Create a new preset and reset the dice results
        let newPreset = Roll(context: moc)
        newPreset.dateRolled = Date.now
        newPreset.isPreset = true
        newPreset.wrappedDice = currentRoll.dieEntityDice(context: moc)
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
        currentRoll.adoptRoll(rollEntity: newPreset)
    }
    
    // Determine a result for each die
    func rollDice() async {
        
        // Animate pre-roll
        await playRollingAnimation()
        
        // Create a new Roll and randomize the dice results
        let newRoll = Roll(context: moc)
        newRoll.dateRolled = Date.now
        newRoll.isPreset = false
        newRoll.wrappedDice = currentRoll.dieEntityDice(context: moc)
        newRoll.presetName = currentRoll.presetName
        newRoll.randomizeDiceResults()
        
        // Append the new roll to the rolls array
        if moc.hasChanges {
            try? moc.save()
        }
        
        // Set the new role as the current roll
        currentRoll.adoptRoll(rollEntity: newRoll)
    }
    
    // Animate the roll results before presenting the final results
    func playRollingAnimation() async {
        
        // Set animation state to true
        rollIsAnimating = true
        
        // Display a random possible result on every timer fire
        let timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                currentRoll.randomizeDiceResults()
            }
        
        // Wait for one second
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Set animation state to false
        rollIsAnimating = false
        
        // Cancel the timer
        timer.cancel()
    }
}

//#Preview {
//    RollWindowButtons()
//}
