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
                    deleteAllRolls()
                    
                    // Reset the current roll
                    currentRoll = LocalRoll()
                }
            }, message: {
                Text("All roll history will be permenantly deleted.")
            })
        }
    }
    
    // Remove all rolls from core data
    func deleteAllRolls() {
        
        // Create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Roll")
        let predicate = NSPredicate(format: "isPreset = %d", false)
        fetchRequest.predicate = predicate

        // Create batch delete request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        // Provide the deleted objects' ids upon removal
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        do {
            
            // Execute the batch delete
            let batchDelete = try moc.execute(batchDeleteRequest) as? NSBatchDeleteResult
            
            // Get the resulting array of object ids
            guard let deletedObjectIds = batchDelete?.result as? [NSManagedObjectID] else { return }
            
            // Create a dictionary with the deleted object ids
            let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deletedObjectIds]

            // Merge the delete changes into the managed object context
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [moc])
        } catch {
            print("Error removing roll history: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    RollHistoryHeader()
//}
