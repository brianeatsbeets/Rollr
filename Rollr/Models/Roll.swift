//
//  Roll.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

import Foundation
//import SwiftData

//@Model
struct Roll: Identifiable {
    let id = UUID()
    var dice: [Die]
    let dateRolled = Date.now
    var presetName: String
    
    var rollTotal: Int {
        dice.reduce(into: 0, { $0 += $1.result })
    }
    var modifierTotal: Int {
        dice.reduce(into: 0, { $0 += $1.modifier })
    }
    var grandTotal: Int {
        rollTotal + modifierTotal
    }
    
    init() {
        self.dice = [Die]()
        self.presetName = ""
    }
    
    init(dice: [Die], presetName: String = "") {
        self.dice = dice
        self.presetName = presetName
        resetDiceIds()
    }
    
    // Re-create each die with a new id
    // This fixes an edge case where loading a preset, changing a modifier, and then re-loading a preset would result in the preset name not being recorded in the roll history
    // This happens because each die is identified by an id, and if an existing die has an id that matches a preset die id AND has a different modifier value, the .onChange() modifier is triggered, which clears the preset name
    mutating func resetDiceIds() {
        dice.indices.forEach {
            let die = dice[$0]
            dice[$0] = Die(numberOfSides: die.numberOfSides, modifier: die.modifier, result: die.result)
        }
    }
    
    mutating func resetDiceResults() {
        dice.indices.forEach {
            dice[$0].result = 0
        }
    }
    
    mutating func randomizeDiceResults() {
        dice.indices.forEach {
            dice[$0].result = Int.random(in: 1...dice[$0].numberOfSides.rawValue)
        }
    }
}
