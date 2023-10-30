//
//  RollrApp.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

// MARK: - Imported libraries

import CoreData
import SwiftUI

// MARK: - Main struct

@main
struct RollrApp: App {
    
    // MARK: - Properties
    
    // StateObject
    
    @StateObject private var dataController = DataController()
    
    // MARK: - Body view
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
            
                // Inject the persistent container's view context into the environment's managed object context
                .environment(\.managedObjectContext, dataController.container.viewContext)
            
                // Set font design
                .fontDesign(.rounded)
        }
    }
}
