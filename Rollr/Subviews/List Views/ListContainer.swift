//
//  ListContainer.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 11/6/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of previous rolls
struct ListContainer: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // Fetch request
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateRolled, order: .reverse)], predicate: NSPredicate(format: "isPreset = %d", false), animation: .default) var rolls: FetchedResults<Roll>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateRolled, order: .reverse)], predicate: NSPredicate(format: "isPreset = %d", true), animation: .default) var presets: FetchedResults<Roll>
    
    // State
    
    @State private var pickerSelection: Int = 1
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        VStack(spacing: 5) {
            
            // List header
            ListContainerHeader(pickerSelection: $pickerSelection)
                .padding(.bottom, 10)
            
            // List container
            List {
                
                if pickerSelection == 1 {
                    
                    // Roll history list
                    ForEach(rolls) { roll in
                        
                        // Individual row
                        RollHistoryRow(roll: roll)
                    }
                    .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                } else {
                    
                    // Presets list
                    ForEach(presets) { preset in
                        
                        // Individual roll
                        Button {
                            presetSelected(preset: preset)
                        } label: {
                            PresetRow(preset: preset) { selectedPreset in
                                presetSelected(preset: selectedPreset)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                    .onDelete(perform: deletePresets)
                }
            }
            
            // Retain the default backgroud color when dataset is empty
            .background(Color(uiColor: .systemGroupedBackground))
            .scrollContentBackground(.hidden)
            
            // Prevent list from bleeding into safe area while in landscape mode
            .mask {
                Rectangle().edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    // Use the selected preset
    func presetSelected(preset: Roll) {
        
        // Clear die value offsets
        animationStateManager.diceValueOffsets.removeAll()
        
        // Add a die value offset for each die
        for _ in preset.wrappedDice {
            animationStateManager.diceValueOffsets.append(-150)
        }
        
        // Set the current roll to a new roll with the selected preset values
        currentRoll.adoptRoll(rollEntity: preset)
    }
    
    // Delete the specifed rolls
    func deleteRolls(_ indexSet: IndexSet) {
        for index in indexSet {
            let roll = rolls[index]
            moc.delete(roll)
        }
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
    }
}

//#Preview {
//    ListContainer()
//}
