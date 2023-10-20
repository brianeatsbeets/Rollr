//
//  Roll.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/18/23.
//

import Foundation
import SwiftData

@Model
final class Roll: Identifiable {
    let id = UUID()
    let values: [Int]
    let total: Int
    let rollSettings: RollSettings
    let dateRolled: Date
    
    init(values: [Int] = [Int.random(in: 1...6)], rollSettings: RollSettings) {
        self.values = values
        total = values.reduce(0) { $0 + $1 }
        self.rollSettings = rollSettings
        dateRolled = Date.now
    }
    
    static var maxRoll = Roll(values: [100, 100, 100, 100, 100], rollSettings: RollSettings(numberOfDice: 5, numberOfSides: 100))
}
