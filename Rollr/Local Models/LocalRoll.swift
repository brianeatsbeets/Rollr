//
//  LocalRoll.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/30/23.
//

// MARK: - Imported libraries

import CoreData
import Foundation

// MARK: - Main class

// This class defines the LocalRoll model
class LocalRoll: Identifiable, ObservableObject {

    // MARK: - Properties

    var id = UUID()
    var dateRolled = Date.now
    @Published var dice: [LocalDie]
    @Published var presetName: String

    var rollTotal: Int {
        dice.reduce(into: 0, { $0 += $1.result })
    }
    var modifierTotal: Int {
        dice.reduce(into: 0, { $0 += $1.modifier })
    }
    var grandTotal: Int {
        rollTotal + modifierTotal
    }

    // MARK: - Initializers

    // Empty roll
    init() {
        self.dice = [LocalDie]()
        self.presetName = ""
    }
    
    // Reset the current roll's properties
    func reset() {
        id = UUID()
        dateRolled = Date.now
        dice = []
        presetName = ""
    }
    
    // Update roll properties to match provided roll
    func adoptRoll(rollEntity: Roll) {
        id = UUID()
        presetName = rollEntity.wrappedPresetName
        dice = []
        
        for die in rollEntity.wrappedDice {
            dice.append(LocalDie(dieEntity: die))
        }
    }

    // Set each die roll result to zero
    func resetDiceResults() {
        dice.indices.forEach {
            dice[$0].result = 0
        }
    }
    
    // Simulate a roll for each die
    func randomizeDiceResults(animating: Bool = false) {
        dice.indices.forEach {
            
            // Calculate a new random result for the specified die
            var newValue = Int.random(in: 1...dice[$0].numberOfSides.rawValue)
            
            // If we're playing the rolling animation, display random a result that doesn't match the previous one
            if animating {
                let oldValue = dice[$0].result
                
                while newValue == oldValue {
                    newValue = Int.random(in: 1...dice[$0].numberOfSides.rawValue)
                }
            }
            
            dice[$0].result = newValue
        }
    }
    
    // Return the dice array as an array of Die (instead of LocalDie)
    func dieEntityDice(context: NSManagedObjectContext) -> [Die] {
        var newDice = [Die]()
        
        for die in dice {
            let newDie = Die(context: context)
            newDie.dateCreated = die.dateCreated
            newDie.numberOfSides = die.numberOfSides
            newDie.modifier = Int16(die.modifier)
            newDie.result = Int16(die.result)
            newDice.append(newDie)
        }
        
        return newDice
    }
    
    static func maxRoll() -> LocalRoll {
        var roll = LocalRoll()
        roll.dice = [LocalDie(numberOfSides: .oneHundred, modifier: 10, result: 100), LocalDie(numberOfSides: .oneHundred, modifier: 10, result: 100), LocalDie(numberOfSides: .oneHundred, modifier: 10, result: 100), LocalDie(numberOfSides: .oneHundred, modifier: 10, result: 100), LocalDie(numberOfSides: .oneHundred, modifier: 10, result: 100)]
        roll.presetName = "Maximum Possible Potential RollResult"
        return roll
    }
}
