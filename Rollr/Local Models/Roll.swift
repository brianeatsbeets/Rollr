////
////  Roll.swift
////  Rollr
////
////  Created by Aguirre, Brian P. on 10/18/23.
////
//
//// MARK: - Imported libraries
//
//import Foundation
//
//// MARK: - Main struct
//
//// This struct defines the Roll model
//struct Roll: Identifiable {
//    
//    // MARK: - Properties
//    
//    let id = UUID()
//    let dateRolled = Date.now
//    var dice: [Die]
//    var presetName: String
//    
//    var rollTotal: Int {
//        dice.reduce(into: 0, { $0 += $1.result })
//    }
//    var modifierTotal: Int {
//        dice.reduce(into: 0, { $0 += $1.modifier })
//    }
//    var grandTotal: Int {
//        rollTotal + modifierTotal
//    }
//    
//    // MARK: - Initializers
//    
//    // Empty roll
//    init() {
//        self.dice = [Die]()
//        self.presetName = ""
//    }
//    
//    // Roll with specified dice and optional preset name
//    init(dice: [Die], presetName: String = "") {
//        self.dice = dice
//        self.presetName = presetName
//        resetDiceIds()
//    }
//    
//    // Re-create each die with a new id
//    // This fixes an edge case where loading a preset, changing a modifier, and then re-loading a preset would result in the preset name not being recorded in the roll history
//    // This happens because each die is identified by an id, and if an existing die has an id that matches a preset die id AND has a different modifier value, the .onChange() modifier is triggered, which clears the preset name
//    mutating func resetDiceIds() {
//        dice.indices.forEach {
//            let die = dice[$0]
//            dice[$0] = Die(numberOfSides: die.numberOfSides, modifier: die.modifier, result: die.result)
//        }
//    }
//    
//    // Set each die roll result to zero
//    mutating func resetDiceResults() {
//        dice.indices.forEach {
//            dice[$0].result = 0
//        }
//    }
//    
//    // Simulate a roll for each die
//    mutating func randomizeDiceResults() {
//        dice.indices.forEach {
//            dice[$0].result = Int.random(in: 1...dice[$0].numberOfSides.rawValue)
//        }
//    }
//    
//    // Example roll
//    static var maxRoll = Roll(dice: [Die(numberOfSides: .oneHundred, modifier: 4, result: 100), Die(numberOfSides: .oneHundred, modifier: 4, result: 100), Die(numberOfSides: .oneHundred, modifier: 4, result: 100), Die(numberOfSides: .oneHundred, modifier: 4, result: 100), Die(numberOfSides: .oneHundred, modifier: 4, result: 100)], presetName: "Catastrophic Planetary Devastation")
//}