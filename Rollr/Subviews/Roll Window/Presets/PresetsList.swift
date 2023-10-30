//
//  PresetsList.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/24/23.
//

// MARK: - Imported libraries

import CoreData
import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of created roll presets
struct PresetsList: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var currentRoll: LocalRoll
    
    // State
    
    @State private var editMode: EditMode = .inactive
    @State private var showingConfirmationAlert = false
    
    // Basic
    
    var presets: FetchedResults<Roll>
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
                    PresetRow(preset: preset)
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
                
                // Set edit mode to inactive
                editMode = .inactive
                
                // Remove all presets
                DataController.deleteEntityRecords(entityName: "Roll", predicate: NSPredicate(format: "isPreset = %d", true), moc: moc)
                
                // Reset the current roll if a preset is active
                if !currentRoll.presetName.isEmpty {
                    currentRoll.reset()
                }
                
                // Dismiss the view
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
            
            // Remove the active preset if it is deleted
            if presets[index].presetName == currentRoll.presetName {
                currentRoll.reset()
            }
            
            //presets.remove(at: index)
            let preset = presets[index]
            moc.delete(preset)
        }
        
        // Dismiss if there are no presets left
        if presets.isEmpty {
            dismiss()
        }
    }
}

//#Preview {
//    NavigationView {
//        PresetsList(presets: .constant([Roll(dice: [Die(numberOfSides: .six, modifier: 3, result: 0), Die(numberOfSides: .twenty, modifier: 0, result: 0), Die(numberOfSides: .twenty, modifier: 0, result: 0)], presetName: "Thor")]), completion: {_ in })
//    }
//}
