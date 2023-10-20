//
//  ContentView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    // User defaults storage
    @AppStorage("numberOfDice") private var numberOfDice = 1
    @AppStorage("numberOfSides") private var numberOfSides = 6
    
    // Environment
    @Environment(\.modelContext) var modelContext
    
    // Swift data query
    @Query(sort: \Roll.dateRolled, order: .reverse, animation: .default) var rolls: [Roll]
    
    
    // State
    @State private var latestRoll: Roll?
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            
            // Main stack
            VStack(spacing: 0) {
                
                // Roll window
                RollWindow(showingSettings: $showingSettings, numberOfDice: $numberOfDice, numberOfSides: $numberOfSides, latestRoll: $latestRoll)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                
                // Roll history header
                RollHistoryHeader(latestRoll: $latestRoll)
                    .padding(.bottom, 5)
                
                // Roll history list
                List {
                    ForEach(rolls) { roll in
                        RollHistoryRow(roll: roll)
                    }
                    .onDelete(perform: deleteRolls)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Rollr")
            .background(Color(uiColor: UIColor.systemGroupedBackground))
            .sheet(isPresented: $showingSettings) {
                RollSettingsView(numberOfDice: $numberOfDice, numberOfSides: $numberOfSides)
            }
        }
    }
    
    func deleteRolls(_ indexSet: IndexSet) {
        for index in indexSet {
            let roll = rolls[index]
            modelContext.delete(roll)
        }
    }
}

//#Preview {
//    ContentView()
//}
