//
//  RollSettings.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import Foundation
//import SwiftData

//@Model
class RollSettings {
    var dice: [Die]
    
    init(dice: [Die]) {
        self.dice = dice
    }
}
