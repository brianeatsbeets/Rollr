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
