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
    @State private var presets = [RollSettings]()
    
    // State
    @State private var dice = [Die]()
    @State private var latestRoll: Roll?
    
    var body: some View {
        NavigationStack {
                
            // Main stack
            VStack(spacing: 0) {
                
                // Roll window
                RollWindow(rolls: $rolls, presets: $presets, dice: $dice, latestRoll: $latestRoll)
                    .padding([.horizontal, .bottom])
                
                // Dice options
                HStack {
                    ForEach(NumberOfSides.allCases, id: \.self) { sides in
                        Button {
                            dice.append(Die(numberOfSides: sides))
                            
                            // Reset each die result
                            dice.indices.forEach {
                                dice[$0].result = 0
                            }
                            
                        } label: {
                            SidesHexagon(numberOfSides: sides.rawValue, type: .button)
                        }
                        .disabled(dice.count >= 5)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding()
                
                // Roll history header
                RollHistoryHeader(latestRoll: $latestRoll, rolls: $rolls, dice: $dice)
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
