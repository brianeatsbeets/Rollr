//
//  LocalDie.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/30/23.
//

// MARK: - Imported libraries

import Foundation

// MARK: - Main struct

// This struct defines the LocalDie model, which is used to track the state of the dice in the current roll (not stored in Core Data)
struct LocalDie: Identifiable {

    // MARK: - Properties

    let id = UUID()
    let dateCreated = Date.now
    let numberOfSides: NumberOfSides
    var modifier: Int
    var result: Int

    var total: Int {
        result + modifier
    }
    var modifierFormatted: String {
        if modifier >= 0 {
            return "+\(modifier)"
        } else {
            return String(modifier)
        }
    }
    var totalExpressionFormatted: String {
        if modifier > 0 {
            return "\(result)+\(modifier)"
        } else if modifier < 0 {
            return "\(result)-\(abs(modifier))"
        } else {
            return String(result)
        }
    }

    // MARK: - Initializers

    init(numberOfSides: NumberOfSides, modifier: Int = 0, result: Int = 0) {
        self.numberOfSides = numberOfSides
        self.modifier = modifier
        self.result = result
    }
    
    init(dieEntity: Die) {
        self.numberOfSides = dieEntity.numberOfSides
        self.modifier = Int(dieEntity.modifier)
        self.result = Int(dieEntity.result)
    }
}
