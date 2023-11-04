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
    
    // Determines if roll results are actively animating after tapping roll button (used to temporarily disable various buttons)
    var rollAnimationIsActive = false
    
    // Tracked to prevent max/min roll result images from re-animating after changing device orientation (view gets re-drawn due to using AdaptiveStack)
    var orientationDidChange = false
    
    // Stored offsets of RollWindowDiceValues that don't get reset when the view gets re-drawn after changing device orientation
    @Published var diceValueOffsets: [CGFloat] = [-150, -150, -150, -150, -150]
}
