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
                VStack(spacing: 0) {
                    Text("Total")
                    Text(roll.total, format: .number)
                        .font(.largeTitle.bold())
                        .frame(width: 75, alignment: .center)
                }
            }
            
            HStack {
                ForEach(roll.rollSettings.dice, id: \.id) { die in
                    VStack {
                        
                        // Roll settings values
                        SidesHexagon(numberOfSides: die.numberOfSides.rawValue)
                            .frame(height: 25)
                        
                        // Roll values
                        Text(die.result.description)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}

//#Preview {
//    RollHistoryRow()
//}
