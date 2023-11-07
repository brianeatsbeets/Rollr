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
        VStack(spacing: 3) {
            
            // Preset name
            HStack {
                if !roll.wrappedPresetName.isEmpty {
                    Text(roll.wrappedPresetName)
                        .font(.headline.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                
                Spacer()
            }
            
            // Roll info and results
            HStack(spacing: 5) {
                
                // Roll info
                VStack(alignment: .leading) {
                    
                    // Date
                    Text(roll.wrappedDateRolled.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                    
                    // Time
                    Text(roll.wrappedDateRolled.formatted(date: .omitted, time: .standard))
                        .font(.caption.bold())
                    
                    // Grand total
                    Text("GTotal: \(roll.grandTotal)")
                        .font(.footnote.bold())
                }
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(minWidth: 60)
                
                Spacer()
                
                // Roll values
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(roll.wrappedDice) { die in
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
                            .frame(width: 30)
                            
                            // Add a divider unless we're on the last die
                            if !die.objectID.isEqual(roll.wrappedDice.last?.objectID) {
                                Divider()
                            }
                        }
                    }
                }
                // Don't allow the view to scroll unless it the size of the content exceeds the size of the container
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
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
