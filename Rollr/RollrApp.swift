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
    @StateObject private var animationStateManager = AnimationStateManager()
    
    // MARK: - Body view
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
            
                // Inject the persistent container's view context into the environment's managed object context
                .environment(\.managedObjectContext, dataController.container.viewContext)
            
                // Inject the current roll object into the environment
                .environmentObject(currentRoll)
            
                // Inject the animation state manager object into the environment
                .environmentObject(animationStateManager)
            
                // Set font design
                .fontDesign(.rounded)
        }
    }
}
