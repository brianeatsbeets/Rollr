//
//  AnimationStateManager.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 11/3/23.
//

// MARK: - Imported libraries

import Foundation

// MARK: - Main class

// This class defines a model that maintains various properties required for UI element animations
class AnimationStateManager: ObservableObject {
    
    // MARK: - Properties
    
    var rollAnimationIsActive = false
    var orientationDidChange = false
    @Published var chooseYourDiceOffset = 0.0
    @Published var diceValueOffsets: [CGFloat] = [-150, -150, -150, -150, -150]
}
