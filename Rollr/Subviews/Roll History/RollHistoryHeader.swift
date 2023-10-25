//
//  RollHistoryHeader.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollHistoryHeader: View {
    
    // Environment
    //@Environment(\.modelContext) var modelContext
    
    // State
    @State private var showingClearHistoryConfirmation = false
    
    // Binding
    @Binding var rolls: [Roll]
    @Binding var currentRoll: Roll
    
    var body: some View {
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
