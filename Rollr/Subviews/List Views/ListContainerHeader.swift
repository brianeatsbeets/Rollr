//
//  ListContainerHeader.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import CoreData
import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a header for the roll history list
struct ListContainerHeader: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // State
    
    @State private var showingClearHistoryConfirmation = false
    @State private var showingClearPresetsConfirmation = false
    @Binding var pickerSelection: Int
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            
            // Delete button
            Group {
                if pickerSelection == 1 {
                    
                    // Clear history button
                    Button(role: .destructive) {
                        showingClearHistoryConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                    // Confirmation for clearing history
                    .confirmationDialog("Clear Roll History", isPresented: $showingClearHistoryConfirmation, actions: {
                        Button("Cancel", role: .cancel) { }
                        Button("Clear History", role: .destructive) {
                            
                            // Clear roll history
                            DataController.deleteEntityRecords(entityName: "Roll", predicate: NSPredicate(format: "isPreset = %d", false), moc: moc)
                            
                            withAnimation {
                                currentRoll.reset()
                            }
                            
                            // Reset RollWindowDiceValues view offsets
                            animationStateManager.diceValueOffsets.removeAll()
                        }
                    }, message: {
                        Text("All roll history data will be permenantly deleted.")
                    })
                } else {
                    Button(role: .destructive) {
                        showingClearPresetsConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                    // Confirmation for removing all presets
                    .confirmationDialog("Remove All Presets", isPresented: $showingClearPresetsConfirmation, actions: {
                        Button("Clear Presets", role: .destructive) {
                            
                            // Remove all presets
                            DataController.deleteEntityRecords(entityName: "Roll", predicate: NSPredicate(format: "isPreset = %d", true), moc: moc)
                            
                            // Reset the current roll if a preset is active
                            if !currentRoll.presetName.isEmpty {
                                withAnimation {
                                    currentRoll.reset()
                                }
                                
                                // Reset RollWindowDiceValues view offsets
                                animationStateManager.diceValueOffsets.removeAll()
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }, message: {
                        Text("All presets will be permenantly deleted.")
                    })
                }
            }
            .padding(.leading)
            
            // Segmented picker
            Picker("Menu", selection: $pickerSelection) {
                Text("Roll History")
                    .tag(1)
                Text("Presets")
                    .tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.trailing)
        }
    }
}

//#Preview {
//    ListContainerHeader()
//}
