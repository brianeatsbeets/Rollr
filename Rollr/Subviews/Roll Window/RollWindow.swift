//
//  RollWindow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import SwiftUI

struct RollWindow: View {
    
    // Environment
    //@Environment(\.modelContext) var modelContext
    
    @State var showingModifierView = false
    @State var dieBeingModified: Die?
    @State var selectedModifier = 0
    @State var showingResults = false
    
    // Binding
    @Binding var rolls: [Roll]
    @Binding var dice: [Die]
    @Binding var latestRoll: Roll?
    
    let modifierOptions = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]
    
    var body: some View {
        ZStack {
            
            // Background
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
            
            // Roll reset button
            VStack {
                Spacer()
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button(role: .destructive) {
                        dice.removeAll()
                    } label: {
                        Image(systemName: "trash")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
                    .padding([.bottom, .trailing], 15)
                }
            }
            
            // Dice and values
            if dice.isEmpty {
                Text("Choose your dice!")
                    .font(.title)
                    .padding(.bottom)
            } else {
                VStack {
                    HStack {
                        ForEach($dice, id: \.id) { $die in
                            VStack {
                                
                                // Number of sides
                                SidesHexagon(numberOfSides: die.numberOfSides.rawValue)
                                    .frame(height: 45)
                                
                                // Modifier
                                Menu {
                                    Picker("Modifier", selection: $die.modifier) {
                                        ForEach(modifierOptions, id: \.self) { value in
                                            Text(value.description)
                                        }
                                    }
                                } label: {
                                    ModifierCircle(die: $die)
                                }
                                .frame(height: 35)
                                
                                // Only display if roll was made
                                if showingResults {
                                    
                                    // Roll value
                                    Text(die.result.description)
                                        .font(.title2)
                                    
                                    // Total value
                                    Text(die.total.description)
                                        .font(.title.bold())
                                }
                            }
                            .onChange(of: die.modifier, initial: true) {
                                showingResults = false
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            
            // Roll button
            VStack {
                Spacer()
                
                Button {
                    rollDice()
                    showingResults = true
                } label: {
                    Text("Roll")
                        .font(.headline)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 5)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.tint)
                        )
                }
                .padding(.bottom)
                .disabled(dice.isEmpty)
            }
        }
    }
    
    // Determine a result for each die
    func rollDice() {
        dice.indices.forEach {
            dice[$0].result = Int.random(in: 1...dice[$0].numberOfSides.rawValue)
        }
        
        latestRoll = Roll(rollSettings: RollSettings(dice: dice))
        rolls.append(latestRoll!)
    }
}

//#Preview {
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
