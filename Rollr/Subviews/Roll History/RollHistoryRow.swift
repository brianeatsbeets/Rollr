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
                Text(roll.dateRolled.formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                Text(roll.dateRolled.formatted(date: .omitted, time: .standard))
                    .font(.subheadline.bold())
            }
            
            Spacer()
            
            // Roll values
            ForEach(roll.rollSettings.dice) { die in
                HStack(spacing: 0) {
                    VStack {
                        
                        // Number of sides
                        SidesHexagon(numberOfSides: die.numberOfSides.rawValue, type: .rollHistoryRow, rollValue: die.result)
                            .frame(height: 25)
                        
                        // Roll value + modifier
                        Text(die.totalExpressionFormatted)
                            .font(.footnote)
                            .lineLimit(1)
                        
                        // Roll total
                        Text(die.total.description)
                            .font(.footnote.bold())
                            .lineLimit(1)
                    }
                }
                
                if die.id != roll.rollSettings.dice.last?.id {
                    Divider()
                }
            }
            
            Spacer()
        }
    }
}

//#Preview {
//    RollHistoryRow()
//}
