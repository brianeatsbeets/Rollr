//
//  RollHistoryRow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollHistoryRow: View {
    
    var roll: Roll
    
    var body: some View {
        ZStack {
            HStack {
                
                // Roll date and time
                VStack(alignment: .leading) {
                    Text(roll.dateRolled.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                    Text(roll.dateRolled.formatted(date: .omitted, time: .standard))
                        .font(.subheadline.bold())
                }
                
                Spacer()
                
                // Roll total
                Text(roll.total, format: .number)
                    .font(.largeTitle.bold())
                    .frame(width: 75, alignment: .center)
            }
            
            VStack {
                
                // Roll settings values
                RollSettingsValues(numberOfDice: .constant(roll.rollSettings.numberOfDice), numberOfSides: .constant(roll.rollSettings.numberOfSides), scale: .small)
                
                // Roll values
                Text(roll.values.description)
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
    }
}

//#Preview {
//    RollHistoryRow()
//}
