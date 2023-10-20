//
//  RollSettings.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import Foundation
import SwiftData

@Model
class RollSettings {
    let numberOfDice: Int
    let numberOfSides: Int
    
    init(numberOfDice: Int, numberOfSides: Int) {
        self.numberOfDice = numberOfDice
        self.numberOfSides = numberOfSides
    }
}
