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
    var total: Int
    var rollSettings: RollSettings
    let dateRolled = Date.now
    
    init(rollSettings: RollSettings) {
        total = rollSettings.dice.reduce(into: 0, { $0 += $1.result })
        self.rollSettings = rollSettings
    }
}
