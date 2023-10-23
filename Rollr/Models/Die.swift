//
//  Die.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/21/23.
//

import Foundation
//import SwiftData

//@Model
class Die: Identifiable {
    let id = UUID()
    let numberOfSides: NumberOfSides
    var modifier = 0
    var result = 0
    var total: Int {
        result + modifier
    }
    var modifierFormatted: String {
        if modifier > 0 {
            return "+\(modifier)"
        } else if modifier < 0 {
            return String(modifier)
        } else {
            return "M"
        }
    }
    var totalExpressionFormatted: String {
        if modifier > 0 {
            return "\(result)+\(modifier)"
        } else if modifier < 0 {
            return "\(result)-\(abs(modifier))"
        } else {
            return "-"
        }
    }
    
    init(numberOfSides: NumberOfSides) {
        self.numberOfSides = numberOfSides
    }
}

enum NumberOfSides: Int, Codable, CaseIterable {
    case four = 4
    case six = 6
    case eight = 8
    case ten = 10
    case twelve = 12
    case twenty = 20
    case oneHundred = 100
}
