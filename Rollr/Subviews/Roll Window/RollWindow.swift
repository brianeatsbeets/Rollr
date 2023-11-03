//
//  RollWindow.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the current roll information
struct RollWindow: View {
    
    // MARK: - Properties
    
    // Environment
    
    @Environment(\.colorScheme) var theme
    @EnvironmentObject var currentRoll: LocalRoll
    
    // State
    
    @State private var showingModifierView = false
    @State private var dieBeingModified: Die?
    @State private var rollIsAnimating = false
    @State private var chooseYourDiceOffset = 0.0
    @State private var diceValueOffsets: [CGFloat] = [-150, -150, -150, -150, -150]
    
    // MARK: - Body view
    
    var body: some View {
            
        // Background
        RoundedRectangle(cornerRadius: 10)
            .fill(theme == .light ? Color.white : Color(uiColor: .secondarySystemBackground))
            .overlay(
        
                // Roll window content
                VStack {
                    ZStack {
                        
                        if currentRoll.dice.isEmpty {
                            
                            // Awaiting roll text
                            VStack {
                                Spacer()
                                
                                Text("Choose your dice!")
                                    .font(.title)
                                
                                Spacer()
                            }
                            .offset(y: chooseYourDiceOffset)
                            
                            // Animate up and down on a loop
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: chooseYourDiceOffset)
                            .onAppear {
                                chooseYourDiceOffset = 10
                            }
                            .onDisappear {
                                chooseYourDiceOffset = 0
                            }
                            
                        } else {
                            
                            // Dice info and labels
                            VStack {
                                HStack {
                                    
                                    // Row labels
                                    //if !currentRoll.dice.isEmpty {
                                        VStack(alignment: .leading) {
                                            Text("Dice:")
                                                .frame(maxHeight: .infinity)
                                            
                                            Text("Modifier:")
                                                .frame(maxHeight: .infinity)
                                            
                                            Text("Roll:")
                                                .frame(maxHeight: .infinity)
                                            
                                            Text("Total:")
                                                .bold()
                                                .frame(maxHeight: .infinity)
                                        }
                                        .font(.title3.weight(.medium))
                                        .padding(.leading, 10)
                                        .layoutPriority(1)
                                    //}
                                    
                                    Spacer()
                                    
                                    // Dice and values
                                    RollWindowDiceValues(rollIsAnimating: $rollIsAnimating, diceValueOffsets: $diceValueOffsets)
                                    
                                    Spacer()
                                }
                                .padding([.top, .trailing], 10)
                                
                                // Grand total
                                HStack {
                                    
                                    // Label
                                    Text("Grand total:")
                                        .font(.title3.weight(.medium))
                                        .padding(.leading, 10)
                                    
                                    // Value
                                    Text(rollIsAnimating ? "-" : (currentRoll.rollTotal != 0 ? currentRoll.grandTotal.description : "-"))
                                        .font(.title2.bold())
                                        .minimumScaleFactor(0.5)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom row buttons
                    RollWindowButtons(rollIsAnimating: $rollIsAnimating, diceValueOffsets: $diceValueOffsets)
                }
            )
        
            // Clip new die "fall from above" animation
            .clipped()
    }
}

//#Preview {
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
