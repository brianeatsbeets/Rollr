////
////  Die.swift
////  Rollr
////
////  Created by Aguirre, Brian P. on 10/21/23.
////
//
//// MARK: - Imported libraries
//
//import Foundation
//
//// MARK: - Main struct
//
//// This struct defines the Die model
//struct Die: Identifiable {
//    
//    // MARK: - Properties
//    
//    let id = UUID()
//    let numberOfSides: NumberOfSides
//    var modifier: Int
//    var result: Int
//    
//    var total: Int {
//        result + modifier
//    }
//    var modifierFormatted: String {
//        if modifier >= 0 {
//            return "+\(modifier)"
//        } else {
//            return String(modifier)
//        }
//    }
//    var totalExpressionFormatted: String {
//        if modifier > 0 {
//            return "\(result)+\(modifier)"
//        } else if modifier < 0 {
//            return "\(result)-\(abs(modifier))"
//        } else {
//            return String(result)
//        }
//    }
//    
//    // MARK: - Initializers
//    
//    init(numberOfSides: NumberOfSides, modifier: Int = 0, result: Int = 0) {
//        self.numberOfSides = numberOfSides
//        self.modifier = modifier
//        self.result = result
//    }
//}
//
//// MARK: - Enums
//
//// This enum provides options for the number of sides on a die
//enum NumberOfSides: Int, CaseIterable {
//    case four = 4
//    case six = 6
//    case eight = 8
//    case ten = 10
//    case twelve = 12
//    case twenty = 20
//    case oneHundred = 100
//}
