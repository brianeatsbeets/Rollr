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
}
