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
    //@Environment(\.modelContext) var modelContext
    
    // Swift data query
    //@Query(sort: \Roll.dateRolled, order: .reverse, animation: .default) var rolls: [Roll]
    @State var rolls = [Roll]()
    
    // State
    @State private var dice = [Die]()
    @State private var latestRoll: Roll?
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { geo in
                
                // Main stack
                VStack {
                    
                    // Roll window
                    RollWindow(rolls: $rolls, dice: $dice, latestRoll: $latestRoll)
                        .padding(.horizontal)
                        .frame(height: geo.size.height / 2.5)
                    
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
                                SidesHexagon(numberOfSides: sides.rawValue)
                            }
                            .disabled(dice.count >= 5)
                        }
                    }
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
                }
                .navigationTitle("Rollr")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(uiColor: UIColor.systemGroupedBackground))
            }
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
