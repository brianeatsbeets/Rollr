//
//  RollHistoryRow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollHistoryRow: View {
    
    @Environment(\.colorScheme) var theme
    
    var roll: Roll
    
    var body: some View {
        HStack {
                
            // Roll date and time
            VStack(alignment: .leading) {
                
                // Date
                Text(roll.dateRolled.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                
                // Time
                Text(roll.dateRolled.formatted(date: .omitted, time: .standard))
                    .font(.caption.bold())
                
                // Preset name (if applicable)
                if !roll.presetName.isEmpty {
                    Text(roll.presetName)
                        .font(.footnote.bold())
                }
                
                // Grand total
                Text("GTotal: \(roll.grandTotal)")
                    .font(.footnote.bold())
            }
            .lineLimit(1)
            //.minimumScaleFactor(0.5)
            .layoutPriority(1)
            
            Spacer()
            
            // Roll values
            ForEach(roll.dice) { die in
                HStack(spacing: 0) {
                    VStack {
                        
                        // Number of sides
                        SidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: die.result)
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
                }
                
                // Add a divider unless we're on the last die
                if die.id != roll.dice.last?.id {
                    Divider()
                }
            }
        }
    }
}

#Preview {
    List {
        RollHistoryRow(roll: Roll.maxRoll)
        RollHistoryRow(roll: Roll(dice: [Die(numberOfSides: .six, result: 3), Die(numberOfSides: .six, result: 1), Die(numberOfSides: .six, modifier: 3, result: 6)]))
    }
}
