//
//  RollHistoryHeader.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import CoreData
import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a header for the roll history list
struct RollHistoryHeader: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.managedObjectContext) var moc
    
    // State
    
    @State private var showingClearHistoryConfirmation = false
    
    // Binding
    
    @Binding var currentRoll: LocalRoll
    
    // MARK: - Body view
    
    var body: some View {
        
        // Main stack
        HStack {
            
            // Header text
            Text("Roll History")
                .font(.title2.bold())
                .padding(.leading)
            
            Spacer()
            
            // Clear history button
            Button(role: .destructive) {
                showingClearHistoryConfirmation = true
            } label: {
                Image(systemName: "trash")
            }
            .padding(.trailing)
            
            // Confirmation for clearing history
            .confirmationDialog("Clear Roll History", isPresented: $showingClearHistoryConfirmation, actions: {
                Button("Cancel", role: .cancel) { }
                Button("Clear History", role: .destructive) {
                    
                    // Clear roll history
                    DataController.deleteEntityRecords(entityName: "Roll", predicate: NSPredicate(format: "isPreset = %d", false), moc: moc)
                    
                    // Reset the current roll
                    currentRoll = LocalRoll()
                }
            }, message: {
                Text("All roll history will be permenantly deleted.")
            })
        }
    }
    
    
}

//#Preview {
//    RollHistoryHeader()
//}
