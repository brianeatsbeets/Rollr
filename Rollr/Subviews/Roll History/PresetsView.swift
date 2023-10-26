//
//  PresetsView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/24/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of created roll presets
struct PresetsView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.dismiss) var dismiss
    
    // State
    
    @State private var editMode: EditMode = .inactive
    @State private var showingConfirmationAlert = false
    
    // Binding
    
    @Binding var presets: [Roll]
    @Binding var currentRoll: Roll
    
    // Basic
    
    let completion: (Roll) -> Void
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main list
        List {
            ForEach(presets) { preset in
                
                // Individual roll
                Button {
                    completion(preset)
                    dismiss()
                } label: {
                    HStack {
                        
                        // Name
                        Text(preset.presetName)
                            .font(.title2.weight(.semibold))
                            .lineLimit(2)
                            .minimumScaleFactor(0.3)
                        
                        Spacer()
                        
                        // Dice settings
                        ForEach(preset.dice) { die in
                            HStack(spacing: 0) {
                                VStack {
                                    
                                    // Number of sides
                                    NumberOfSidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: die.result)
                                        .frame(height: 25)
                                    
                                    // Roll value + modifier
                                    Text(die.modifierFormatted)
                                        .font(.footnote)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            .onDelete(perform: deletePresets)
        }
        .navigationTitle("Load Preset")
        .navigationBarTitleDisplayMode(.inline)
        
        // Confirmation for removing all presets
        .confirmationDialog("Remove All Presets", isPresented: $showingConfirmationAlert, actions: {
            Button("Remove", role: .destructive) {
                presets.removeAll()
                editMode = .inactive
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("All presets will be permenantly deleted.")
        })
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
                
                // Show remove all button when in edit mode
                if editMode == .active {
                    Button("Remove all", role: .destructive) {
                        showingConfirmationAlert = true
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .environment(\.editMode, $editMode)
    }
    
    // Delete the specified presets
    func deletePresets(_ indexSet: IndexSet) {
        for index in indexSet {
//            let roll = rolls[index]
//            modelContext.delete(roll)
            
            // Remove the active preset if it is deleted
            if presets[index].presetName == currentRoll.presetName {
                currentRoll = Roll()
            }
            
            presets.remove(at: index)
        }
        
        // Dismiss if there are no presets left
        if presets.isEmpty {
            dismiss()
        }
    }
}

//#Preview {
//    NavigationView {
//        PresetsView(presets: .constant([Roll(dice: [Die(numberOfSides: .six, modifier: 3, result: 0), Die(numberOfSides: .twenty, modifier: 0, result: 0), Die(numberOfSides: .twenty, modifier: 0, result: 0)], presetName: "Thor")]), completion: {_ in })
//    }
//}
