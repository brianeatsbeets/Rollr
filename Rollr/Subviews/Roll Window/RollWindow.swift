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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var currentRoll: LocalRoll
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // State
    
    @State private var showingModifierView = false
    @State private var dieBeingModified: Die?
    @State private var chooseYourDiceOffset = 0.0
    
    // MARK: - Body view
    
    var body: some View {
            
        // Background
        RoundedRectangle(cornerRadius: 10)
            .fill(theme == .light ? Color.white : Color(uiColor: .secondarySystemBackground))
            .frame(minHeight: verticalSizeClass == .regular ? 300 : 0)
            .overlay(
        
                // Roll window content
                VStack {
                    ZStack {
                        
                        if currentRoll.dice.isEmpty {
                            
                            // Awaiting roll text
                            VStack {
                                Spacer()
                                
                                Text("Choose your dice!")
                                    .font(.title.weight(.semibold))
                                
                                Spacer()
                            }
                            .offset(y: chooseYourDiceOffset)
                            
                            .onAppear {
                                
                                // Animate up and down on a loop
                                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                    chooseYourDiceOffset = 10
                                }
                            }
                            .onDisappear {
                                chooseYourDiceOffset = 0
                            }
                            
                        } else {
                            
                            // Dice info and labels
                            VStack {
                                HStack {
                                    
                                    // Row labels
                                    VStack(alignment: .leading) {
                                        Text("Sides:")
                                            .frame(maxHeight: .infinity)
                                        
                                        Text("Mod:")
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
                                    
                                    Spacer()
                                    
                                    // Dice and values
                                    RollWindowDiceValues()
                                }
                                .padding(.top, 10)
                                
                                // Grand total
                                HStack {
                                    
                                    // Label
                                    Text("Grand total:")
                                        .font(.title3.weight(.medium))
                                        .padding(.leading, 10)
                                    
                                    // Value
                                    Text(animationStateManager.rollAnimationIsActive ? "-" : (currentRoll.rollTotal != 0 ? currentRoll.grandTotal.description : "-"))
                                        .font(.title2.bold())
                                        .minimumScaleFactor(0.5)
                                        .scaleEffect(animationStateManager.rollResultsScale)
                                        .onChange(of: animationStateManager.rollAnimationIsActive) { newValue in
                                            
                                            // Only animate after roll animation has finished
                                            if newValue == false {
                                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                    withAnimation(.easeOut(duration: 0.2)) {
                                                        animationStateManager.rollResultsScale = 1.2
                                                    }
                                                }
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    withAnimation(.easeOut(duration: 0.1)) {
                                                        animationStateManager.rollResultsScale = 1.0
                                                    }
                                                }
                                            }
                                        }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom row buttons
                    RollWindowButtons()
                }
            )
        
            // Clip new die "fall from above" animation
            .clipped()
    }
}

//#Preview {
//    RollWindow(rolls: .constant([Roll] ()), dice: .constant([Die(numberOfSides: .eight)]), latestRoll: .constant(nil))
//}
