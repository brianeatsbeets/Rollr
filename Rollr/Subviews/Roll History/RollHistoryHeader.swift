//
//  RollHistoryHeader.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays a header for the roll history list
struct RollHistoryHeader: View {
    
    // MARK: - Properties
    
    // Environment
    
    //@Environment(\.modelContext) var modelContext
    
    // State
    
    @State private var showingClearHistoryConfirmation = false
    
    // Binding
    
    @Binding var rolls: [Roll]
    @Binding var currentRoll: Roll
    
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
                    do {
                        //try modelContext.delete(model: Roll.self)
                        
                        // Clear the roll history
                        rolls.removeAll()
                        
                        // Reset the current roll
                        currentRoll = Roll()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
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
