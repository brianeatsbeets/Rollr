//
//  ListContainer.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 11/6/23.
//

// MARK: - Imported libraries

import CoreData
import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of previous rolls
struct ListContainer: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.managedObjectContext) var moc
    //@EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var currentRollViewModel: LocalRollViewModel
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // Fetch request
    
    //@FetchRequest(sortDescriptors: [SortDescriptor(\.dateRolled, order: .reverse)], predicate: NSPredicate(format: "isPreset = %d", false), animation: .default) var rolls: FetchedResults<Roll>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateRolled, order: .reverse)], predicate: NSPredicate(format: "isPreset = %d", true), animation: .default) var presets: FetchedResults<Roll>
    
    // State
    
    @AppStorage("listContainerPickerSelection") var pickerSelection: Int = 1
    
    // Basic
    
    var rolls: [Roll] {
        dataController.currentSession.wrappedRolls.filter { !$0.isPreset }
    }
    
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
                        
                        // Prevent deleting of a preset from a full swipe (require button tap after reveal)
                        .swipeActions(allowsFullSwipe: false) {
                            Button("Delete", role: .destructive) {
                                deleteSelectedPreset(preset: preset)
                            }
                        }
                    }
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
        
        // Adjust group-styled list top padding
        .onAppear {
            UICollectionView.appearance().contentInset.top = -35
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
        currentRollViewModel.adoptRoll(rollEntity: preset)
        currentRollViewModel.setPresetName(newPresetName: preset.objectID.description)
    }
    
    // Delete the selected preset
    func deleteSelectedPreset(preset: FetchedResults<Roll>.Element) {
        
        // Remove the active preset if it matches the one we're deleting
        if preset.objectID.description == currentRollViewModel.presetId {
            currentRollViewModel.resetRoll()
        }
        
        moc.delete(preset as NSManagedObject)
        try? moc.save()
    }
}

//#Preview {
//    ListContainer()
//}
