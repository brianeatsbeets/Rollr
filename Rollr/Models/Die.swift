//
//  Die.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/21/23.
//

import Foundation
//import SwiftData

//@Model
struct Die: Identifiable {
    var id = UUID()
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
    
    init(numberOfSides: NumberOfSides, modifier: Int = 0, result: Int = 0) {
        self.numberOfSides = numberOfSides
        self.modifier = modifier
        self.result = result
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
