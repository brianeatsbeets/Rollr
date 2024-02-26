//
//  LocalRollViewModel.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 2/11/24.
//

import CoreData

class LocalRollViewModel: ObservableObject {
    
    @Published private var localRoll: LocalRoll
    
    var dice: [LocalDie] {
        localRoll.dice
    }
    var presetId: String {
        localRoll.presetId
    }
    var presetName: String {
        localRoll.presetName
    }
    
    var rollTotal: Int {
        localRoll.dice.reduce(into: 0, { $0 += $1.result })
    }
    var modifierTotal: Int {
        localRoll.dice.reduce(into: 0, { $0 += $1.modifier })
    }
    var grandTotal: Int {
        rollTotal + modifierTotal
    }
    
    init(localRoll: LocalRoll) {
        self.localRoll = localRoll
    }
    
    func setId(newId: UUID) {
        localRoll.id = newId
    }
    
    func setPresetId(newPresetId: String) {
        localRoll.presetId = newPresetId
    }
    
    func setPresetName(newPresetName: String) {
        localRoll.presetName = newPresetName
    }
    
    func addDie(_ newDie: LocalDie) {
        localRoll.dice.append(newDie)
    }
    
    func setDieModifier(index: Int, newVlaue: Int) {
        localRoll.dice[index].modifier = newVlaue
    }
    
    // Reset the current roll's properties
    func resetRoll() {
        localRoll.id = UUID()
        localRoll.dateRolled = Date.now
        localRoll.dice = []
        localRoll.presetId = ""
        localRoll.presetName = ""
    }
    
    // Update roll properties to match provided roll
    func adoptRoll(rollEntity: Roll) {
        localRoll.id = UUID()
        localRoll.presetName = rollEntity.wrappedPresetName
        localRoll.dice = []
        
        for die in rollEntity.wrappedDice {
            localRoll.dice.append(LocalDie(dieEntity: die))
        }
    }

    // Set each die roll result to zero
    func resetDiceResults() {
        localRoll.dice.indices.forEach {
            localRoll.dice[$0].result = 0
        }
    }
    
    // Simulate a roll for each die
    func randomizeDiceResults(animating: Bool = false) {
        localRoll.dice.indices.forEach {
            
            // Calculate a new random result for the specified die
            var newValue = Int.random(in: 1...localRoll.dice[$0].numberOfSides.rawValue)
            
            // If we're playing the rolling animation, display random a result that doesn't match the previous one
            if animating {
                let oldValue = localRoll.dice[$0].result
                
                while newValue == oldValue {
                    newValue = Int.random(in: 1...localRoll.dice[$0].numberOfSides.rawValue)
                }
            }
            
            localRoll.dice[$0].result = newValue
        }
    }
    
    // Return the dice array as an array of Die (instead of LocalDie)
    func dieEntityDice(context: NSManagedObjectContext) -> [Die] {
        var newDice = [Die]()
        
        for die in localRoll.dice {
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
