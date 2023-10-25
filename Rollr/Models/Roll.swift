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
    //var rollSettings: RollSettings
    var dice: [Die]
    let dateRolled = Date.now
    let presetName: String
    
    var rollTotal: Int {
        dice.reduce(into: 0, { $0 += $1.result })
    }
    var modifierTotal: Int {
        dice.reduce(into: 0, { $0 += $1.modifier })
    }
    var grandTotal: Int {
        rollTotal + modifierTotal
    }
    
//    init(rollSettings: RollSettings) {
//        rollTotal = rollSettings.dice.reduce(into: 0, { $0 += $1.result })
//        modifierTotal = rollSettings.dice.reduce(into: 0, { $0 += $1.modifier })
//        grandTotal = rollTotal + modifierTotal
//        self.rollSettings = rollSettings
//    }
    
    init(dice: [Die], presetName: String = "") {
        self.dice = dice
        self.presetName = ""
    }
}
