//
//  PresetsView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/24/23.
//

import SwiftUI

struct PresetsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var editMode: EditMode = .inactive
    @State private var showingConfirmationAlert = false
    
    @Binding var presets: [Roll]
    @Binding var currentRoll: Roll
    
    let completion: (Roll) -> Void
    
    var body: some View {
        
        List {
            ForEach(presets) { preset in
                Button {
                    completion(preset)
                    dismiss()
                } label: {
                    VStack {
                        HStack {
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
                                        SidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: die.result)
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
                }
                .foregroundStyle(.primary)
            }
            .onDelete(perform: deletePresets)
        }
        .navigationTitle("Load Preset")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Remove All Presets", isPresented: $showingConfirmationAlert, actions: {
            Button("Remove", role: .destructive) {
                presets.removeAll()
                editMode = .inactive
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("All presets will be permenantly deleted.")
        })
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
                
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
