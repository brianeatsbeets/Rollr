//
//  ContentView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that serves as the base container for the app
struct ContentView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    @Environment(\.managedObjectContext) var moc
    
    // MARK: - Body view
    
    var body: some View {
        NavigationStack {
            
            // Main stack
            VStack(spacing: 0) {
                
                // Roll window
                RollWindow()
                    .padding([.horizontal, .bottom])
                
                // Dice options
                DiceOptions()
                    .padding(.horizontal)
                
                Divider()
                    .padding()
                
                // Roll history list
                RollHistoryList()
            }
            .navigationTitle("Rollr")
            .navigationBarTitleDisplayMode(.inline)
            .background(theme == .light ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: UIColor.systemGroupedBackground))
            
            // Prevents layout from squishing when entering a new preset name
            .ignoresSafeArea(.keyboard)
        }
    }
}

//#Preview {
//    ContentView()
//}
