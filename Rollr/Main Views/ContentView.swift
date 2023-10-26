//
//  ContentView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

// MARK: - Imported libraries

//import SwiftData
import SwiftUI

// MARK: - Main struct

// This struct provides a view that serves as the base container for the app
struct ContentView: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    //@Environment(\.modelContext) var modelContext
    
    // State
    
    //@Query(sort: \Roll.dateRolled, order: .reverse, animation: .default) var rolls: [Roll]
    @State private var rolls = [Roll]()
    @State private var presets = [Roll]()
    @State private var currentRoll = Roll()
    
    // MARK: - Body view
    
    var body: some View {
        NavigationStack {
            
            // Main stack
            VStack(spacing: 0) {
                
                // Roll window
                RollWindow(rolls: $rolls, presets: $presets, currentRoll: $currentRoll)
                    .padding([.horizontal, .bottom])
                
                // Dice options
                DiceOptions(currentRoll: $currentRoll)
                    .padding(.horizontal)
                
                Divider()
                    .padding()
                
                // Roll history list
                RollHistoryList(rolls: $rolls, currentRoll: $currentRoll)
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
