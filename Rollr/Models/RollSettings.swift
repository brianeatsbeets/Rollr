//
//  RollSettings.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/19/23.
//

import Foundation
//import SwiftData

//@Model
struct RollSettings: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var dice: [Die]
    
    init(name: String = "", dice: [Die]) {
        self.name = name
        self.dice = dice
    }
    
    static func == (lhs: RollSettings, rhs: RollSettings) -> Bool {
        lhs.id == rhs.id
    }
}
