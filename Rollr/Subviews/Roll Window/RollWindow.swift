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
            
            // Row labels
            if !dice.isEmpty {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Dice:")
                            .frame(height: 40)
                        
                        Text("Modifier:")
                            .frame(height: 40)
                        
                        Text("Roll:")
                            .frame(height: 40)
                        
                        Text("Total:")
                            .bold()
                            .frame(height: 40)
                        
                        Spacer()
                    }
                    .font(.title3.weight(.medium))
                    
                    Spacer()
                }
                .padding([.top, .leading], 10)
            }
            
            // Roll window content
            VStack {
                
                // Awaiting roll text
                if dice.isEmpty {
                    VStack {
                        Spacer()
                        Spacer()
                        
                        Text("Choose your dice!")
                            .font(.title)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                } else {
                    
                    // Dice and values
                    VStack {
                        HStack {
                            Spacer()
                            
                            ForEach($dice, id: \.id) { $die in
                                VStack {
                                    
                                    // Number of sides
                                    SidesHexagon(numberOfSides: die.numberOfSides.rawValue)
                                        .frame(height: 40)
                                    
                                    // Modifier
                                    Menu {
                                        Picker("Modifier", selection: $die.modifier) {
                                            ForEach(modifierOptions, id: \.self) { value in
                                                Text(value > 0 ? "+\(value)" : String(value))
                                            }
                                        }
                                    } label: {
                                        ModifierCircle(die: $die)
                                            .frame(height: 30)
                                    }
                                    .frame(height: 40)
                                    
                                    // Roll value
                                    Text(showingResults ? die.result.description : "-")
                                        .font(.title2)
                                        .frame(height: 40)
                                    
                                    // Total value
                                    Text(showingResults ? die.total.description : "-")
                                        .font(.title.bold())
                                        .frame(height: 40)
                                }
                                .onChange(of: die.modifier, initial: true) {
                                    showingResults = false
                                }
                            }
                        }
                        .padding([.top, .trailing], 10)
                        
                        Spacer()
                    }
                }
                
                // Roll + reset buttons
                ZStack {
                    
                    // Roll button
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
                    
                    HStack {
                        Spacer()
                        
                        // Roll reset button
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
