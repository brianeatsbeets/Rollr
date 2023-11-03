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
    @StateObject private var currentRoll = LocalRoll()
    @StateObject private var orientationChecker = OrientationChecker()
    
    // MARK: - Body view
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
            
                // Inject the persistent container's view context into the environment's managed object context
                .environment(\.managedObjectContext, dataController.container.viewContext)
            
                // Inject the current roll object into the environment
                .environmentObject(currentRoll)
            
                // Inject the orientation checker object into the environment
                .environmentObject(orientationChecker)
            
                // Set font design
                .fontDesign(.rounded)
        }
    }
}

class OrientationChecker: ObservableObject {
    var orientationDidChange = false
}
