//
//  Die+CoreDataProperties.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//
//

import Foundation
import CoreData


extension Die {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Die> {
        return NSFetchRequest<Die>(entityName: "Die")
    }

    @NSManaged public var modifier: Int16
    @NSManaged public var result: Int16
    @NSManaged private var numberOfSidesInt: Int16
    @NSManaged public var dateCreated: Date?
    
    var numberOfSides: NumberOfSides {
        get {
            return NumberOfSides(rawValue: Int(self.numberOfSidesInt)) ?? .six
        }
        set {
            self.numberOfSidesInt = Int16(newValue.rawValue)
        }
    }
    
    public var wrappedDateCreated: Date {
        dateCreated ?? Date.now
    }
    
    var total: Int {
        Int(result + modifier)
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

}

extension Die : Identifiable {

}

// MARK: - Enums

// This enum provides options for the number of sides on a die
enum NumberOfSides: Int, CaseIterable {
    case four = 4
    case six = 6
    case eight = 8
    case ten = 10
    case twelve = 12
    case twenty = 20
    case oneHundred = 100
}
