//
//  DataController.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//

// MARK: - Imported libraries

import CoreData

// MARK: - Main class

// This class provides a model that serves as the data source for the core data persistent container
class DataController: ObservableObject {
    
    // MARK: - Properties
    
    let container = NSPersistentContainer(name: "Rollr")
    
    // MARK: - Initializers
    
    init() {
        
        // Load the container's persistent stores
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Convert version 1.0 roll data, if necessary
        if savedSessionExists() == false {
            print("No existing sessions")
            convertPreSessionData()
        } else {
            print("Session data exists")
        }
    }
    
    // MARK: - Functions
    
    // Check if any session data exists
    private func savedSessionExists() -> Bool {
        
        // Create fetch request
        let request = Session.fetchRequest()
        request.fetchLimit = 1
        
        // Attepmt to get result count
        do {
            let count = try container.viewContext.count(for: request)
            return count == 0 ? false : true
        } catch let error as NSError {
            print("Error fetching session data: \(error.localizedDescription)")
            return true
        }
    }
    
    // For users who had created Roll data on v1.0 of the app (before Roll had a session property), add existing rolls to a new session
    // TODO: Set the new session as the active session
    private func convertPreSessionData() {
        
        // Create a new session and add existing roll data to it
        let newSession = Session(context: container.viewContext)
        newSession.dateCreated = Date.now
        newSession.name = "New Session"
        
        // Fetch existing rolls with no session value
        let fetchRequest = Roll.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "session == nil")
        
        // Attempt to fetch
        do {
            let rolls = try container.viewContext.fetch(fetchRequest)
            
            // Assign rolls to the new session
            newSession.wrappedRolls = rolls
            
            print("Successfully added existing rolls to new session")
        } catch {
            print("Error fetching rolls: \(error.localizedDescription)")
        }
        
        try? container.viewContext.save()
    }
    
    // Remove all records for a given entity from core data
    static func deleteEntityRecords(entityName: String, predicate: NSPredicate? = nil, moc: NSManagedObjectContext) {
        
        // Create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // Add predicate (if provided)
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
            print("Error removing entity records: \(error.localizedDescription)")
        }
    }
}
