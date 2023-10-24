//
//  PresetsView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/24/23.
//

import SwiftUI

struct PresetsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var presets: [RollSettings]
    let completion: (RollSettings) -> Void
    
    var body: some View {
        
        List {
            ForEach(presets) { preset in
                Button {
                    completion(preset)
                    dismiss()
                } label: {
                    HStack {
                        Text(preset.name)
                            .font(.title2.weight(.semibold))
                        
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
                        
                        Spacer()
                    }
                }
            }
            .onDelete(perform: deletePresets)
        }
        .navigationTitle("Load Preset")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
    }
    
    func deletePresets(_ indexSet: IndexSet) {
        for index in indexSet {
//            let roll = rolls[index]
//            modelContext.delete(roll)
            presets.remove(at: index)
        }
    }
}

#Preview {
    NavigationView {
        PresetsView(presets: .constant([RollSettings(name: "Thor", dice: [Die(numberOfSides: .six, modifier: 3, result: 0), Die(numberOfSides: .twenty, modifier: 0, result: 0), Die(numberOfSides: .twenty, modifier: 0, result: 0)])]), completion: {_ in })
    }
}
