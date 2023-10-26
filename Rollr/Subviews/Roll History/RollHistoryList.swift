//
//  RollHistoryList.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a list of previous rolls
struct RollHistoryList: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    
    // Binding
    
    @Binding var rolls: [Roll]
    @Binding var currentRoll: Roll
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        VStack(spacing: 5) {
            
            // List header
            RollHistoryHeader(rolls: $rolls, currentRoll: $currentRoll)
            
            // Main list
            List {
                ForEach(rolls.sorted { $0.dateRolled > $1.dateRolled }) { roll in
                    
                    // Individual row
                    RollHistoryRow(roll: roll)
                }
                .onDelete(perform: deleteRolls)
            }
            .listStyle(.plain)
            .background(Color(uiColor: .secondarySystemBackground))
            .scrollContentBackground(theme == .dark ? .hidden : .automatic)
        }
    }
    
    // Delete the specifed rolls
    func deleteRolls(_ indexSet: IndexSet) {
        for index in indexSet {
//            let roll = rolls[index]
//            modelContext.delete(roll)
            rolls.remove(at: index)
        }
    }
}

//#Preview {
//    RollHistoryList()
//}
