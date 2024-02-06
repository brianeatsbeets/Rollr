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
    @Published var currentSession: Session
    
    // MARK: - Initializers
    
    init() {
        
        // Load the container's persistent stores
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Load the previous session
        
        // Fetch from user defaults
        if let lastActiveSessionId = UserDefaults.standard.url(forKey: "lastActiveSessionId") {
            
            // Fetch the managed object id from the url
            if let sessionId = container.viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: lastActiveSessionId) as? NSManagedObjectID,
               
               // Fetch the session object from the managed object id
               let session = container.viewContext.object(with: sessionId) as? Session {
                print("Successfully loaded previous session")
                currentSession = session
            } else {
                print("Couldn't get core data object from id")
                
                // Create a new session
                currentSession = Session(context: container.viewContext)
                currentSession.dateCreated = Date.now
                currentSession.name = "New Session"
                
                try? container.viewContext.save()
            }
        }
        else {
            // If no previous session exists, create a new one
            print("Last active session id is nil, or couldn't cast value as NSManagedObjectID")
            
            // Create a new session and add existing roll data to it
            currentSession = Session(context: container.viewContext)
            currentSession.dateCreated = Date.now
            currentSession.name = "New Session"
            
            // For users who updated from v1.0, set the current session as each roll's session
            convertPreSessionData()
        }
    }
    
    // MARK: - Functions
    
    // For users who had created Roll data on v1.0 of the app (before Roll had a session property), add existing rolls to a the current session (which will be brand new)
    private func convertPreSessionData() {
        
        // Fetch existing rolls with no session value
        let fetchRequest = Roll.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "session == nil")
        
        // Attempt to fetch
        do {
            let rolls = try container.viewContext.fetch(fetchRequest)
            
            // Assign rolls to the new session
            currentSession.wrappedRolls = rolls
            
            try? container.viewContext.save()
            
            UserDefaults.standard.set(currentSession.objectID.uriRepresentation(), forKey: "lastActiveSessionId")
            print("Object id saved to user defaults: \(currentSession.objectID.uriRepresentation())")
            
            print("Successfully added existing rolls to new session")
        } catch {
            print("Error fetching rolls: \(error.localizedDescription)")
        }
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
