//
//  ContentView.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

//import SwiftData
import SwiftUI

struct ContentView: View {
    
    // Environment
    @Environment(\.colorScheme) var theme
    //@Environment(\.modelContext) var modelContext
    
    // Swift data query
    //@Query(sort: \Roll.dateRolled, order: .reverse, animation: .default) var rolls: [Roll]
    @State private var rolls = [Roll]()
//    @State private var presets = [RollSettings]()
    @State private var presets = [Roll]()
    
    // State
    @State private var currentRoll = Roll(dice: [Die]()) //Roll(rollSettings: RollSettings(dice: [Die]()))
    @State private var latestRoll: Roll?
    
    var body: some View {
        NavigationStack {
                
            // Main stack
            VStack(spacing: 0) {
                
                // Roll window
                RollWindow(rolls: $rolls, presets: $presets, currentRoll: $currentRoll, latestRoll: $latestRoll)
                    .padding([.horizontal, .bottom])
                
                // Dice options
                HStack {
                    ForEach(NumberOfSides.allCases, id: \.self) { sides in
                        Button {
                            
                            // Append the selected die to the dice array
                            //currentRoll.rollSettings.dice.append(Die(numberOfSides: sides))
                            currentRoll.dice.append(Die(numberOfSides: sides))
                            
                            // Reset each die result
//                            currentRoll.rollSettings.dice.indices.forEach {
//                                currentRoll.rollSettings.dice[$0].result = 0
//                            }
                            currentRoll.dice.indices.forEach {
                                currentRoll.dice[$0].result = 0
                            }
                            
                            // Re-create the roll settings with the existing die
//                            let newDice = currentRoll.rollSettings.dice
//                            currentRoll.rollSettings = RollSettings(dice: newDice)
                            let newDice = currentRoll.dice
                            currentRoll = Roll(dice: newDice)
                            
                        } label: {
                            SidesHexagon(numberOfSides: sides.rawValue, type: .button)
                        }
                        //.disabled(currentRoll.rollSettings.dice.count >= 5)
                        .disabled(currentRoll.dice.count >= 5)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding()
                
                // Roll history header
                RollHistoryHeader(latestRoll: $latestRoll, rolls: $rolls, currentRoll: $currentRoll)
                    .padding(.bottom, 5)
                
                // Roll history list
                List {
                    ForEach(rolls.sorted { $0.dateRolled > $1.dateRolled }) { roll in
                        RollHistoryRow(roll: roll)
                    }
                    .onDelete(perform: deleteRolls)
                }
                .listStyle(.plain)
                .background(Color(uiColor: .secondarySystemBackground))
                .scrollContentBackground(theme == .dark ? .hidden : .automatic)
            }
            .navigationTitle("Rollr")
            .navigationBarTitleDisplayMode(.inline)
            .background(theme == .light ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: UIColor.systemGroupedBackground))
    }
    }
    
    func deleteRolls(_ indexSet: IndexSet) {
        for index in indexSet {
//            let roll = rolls[index]
//            modelContext.delete(roll)
            rolls.remove(at: index)
        }
    }
}

//#Preview {
//    ContentView()
//}
