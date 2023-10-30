//
//  RollHistoryRow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays historic roll data in a list row
struct RollHistoryRow: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    
    // Basic
    
    var roll: Roll
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
                
            // Roll properties
            VStack(alignment: .leading) {
                
                // Date
                Text(roll.wrappedDateRolled.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                
                // Time
                Text(roll.wrappedDateRolled.formatted(date: .omitted, time: .standard))
                    .font(.caption.bold())
                
                // Preset name (if applicable)
                if !roll.wrappedPresetName.isEmpty {
                    Text(roll.wrappedPresetName)
                        .font(.footnote.bold().leading(.tight))
                        .lineSpacing(-1)
                        .lineLimit(3)
                }
                
                // Grand total
                Text("GTotal: \(roll.grandTotal)")
                    .font(.footnote.bold())
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            
            Spacer()
            
            // Roll values
            ForEach(roll.wrappedDice) { die in
                HStack(spacing: 0) {
                    VStack {
                        
                        // Number of sides
                        NumberOfSidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: Int(die.result))
                            .frame(height: 25)
                        
                        // Roll value + modifier
                        Text(die.totalExpressionFormatted)
                            .font(.footnote)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        // Roll total
                        Text(die.total.description)
                            .font(.footnote.bold())
                            .lineLimit(1)
                    }
                }.onAppear {
                    print("result: \(die.result)")
                    print("die id: \(die.objectID)")
                    guard let lastId = roll.wrappedDice.last?.objectID else { print("No last id"); return }
                    print("lst id: \(lastId)")
                    print("is equal: \(die.objectID.isEqual(roll.wrappedDice.last?.objectID))")
                    print()
                }
                
                // Add a divider unless we're on the last die
                if !die.objectID.isEqual(roll.wrappedDice.last?.objectID) {
                    Divider()
                }
            }
        }
    }
}

//#Preview {
//    List {
//        RollHistoryRow(roll: Roll.maxRoll)
//        RollHistoryRow(roll: Roll(dice: [Die(numberOfSides: .six, result: 3), Die(numberOfSides: .six, result: 1), Die(numberOfSides: .six, modifier: 3, result: 6)]))
//    }
//}
