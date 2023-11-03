//
//  RollValueCircle.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/23/23.
//

// MARK: - Imported libraries

import SwiftUI

// MARK: - Main struct

// This struct provides a view that displays the the roll value of a given die
struct RollValueShape: View {
    
    // MARK: - Properties
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var animationStateManager: AnimationStateManager
    
    // State
    
    @State private var rotationAngle = 0.0
    @State private var scaleAmount = 1.0
    @State private var offset = 0.0
    
    // Binding
    
    @Binding var die: LocalDie
    
    // Basic
    
    var rollResult: String {
        die.result > 0 ? die.result.description : "-"
    }
    var backgroundSymbol: String {
        if die.result == 1 {
            return "square.fill"
        } else {
            return "burst.fill"
        }
    }
    var scaleEffect: CGFloat {
        if die.result == die.numberOfSides.rawValue {
            return 1.25
        } else {
            return 0.85
        }
    }
    var shapeColor: Color {
        if die.result == 1 {
            return .red
        } else {
            return .green
        }
    }
    
    // MARK: - Body view
    
    var body: some View {
        
        // Shape image
        Image(systemName: backgroundSymbol)
            .resizable()
            .scaledToFit()
            .scaleEffect(scaleEffect)
            .foregroundStyle(shapeColor)
            .overlay(
                
                // Roll value
                Text(rollResult)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 5)
            )
            .rotationEffect(.degrees(rotationAngle))
            .scaleEffect(scaleAmount)
            .offset(x: offset)
            .onAppear {
                
                // Don't animate the max/min images during an orientation change
                // (the view gets redrawn during orientation changes due to the conditional layout based on orientation in ContentView)
                if !animationStateManager.orientationDidChange {
                    
                    // Max roll result
                    
                    if die.result == die.numberOfSides.rawValue {
                        
                        // Spin + shrink animation
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                rotationAngle = 360
                                scaleAmount = 0.5
                            }
                        }
                        
                        // Expand animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeIn(duration: 0.1)) {
                                scaleAmount = 1.3
                            }
                        }
                        
                        // Revert to normal size animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                scaleAmount = 1.0
                            }
                        }
                        
                    } else {
                        // Min roll result
                        
                        scaleAmount = 0.1
                        
                        // Spin + shrink animation
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            withAnimation(.easeIn(duration: 0.2)) {
                                scaleAmount = 1.0
                            }
                        }
                        
                        // Expand animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.linear(duration: 0.05)) {
                                offset = -3
                            }
                        }
                        
                        // Expand animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.linear(duration: 0.05)) {
                                offset = 3
                            }
                        }
                        
                        // Expand animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            withAnimation(.linear(duration: 0.05)) {
                                offset = -3
                            }
                        }
                        // Expand animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.linear(duration: 0.05)) {
                                offset = 3
                            }
                        }
                        
                        // Expand animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            withAnimation(.linear(duration: 0.05)) {
                                offset = 0
                            }
                        }
                    }
                }
            }
            .onChange(of: verticalSizeClass) { newValue in
                animationStateManager.orientationDidChange = true
            }
    }
}

//#Preview {
//    HStack {
//        RollValueShape(showingResults: .constant(true), die: .constant(Die.maxRoll))
//    }
//    .frame(height: 40)
//}
