//
//  Roll+CoreDataProperties.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 10/26/23.
//
//

import CoreData
import Foundation
import SwiftUI

extension Roll {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roll> {
        return NSFetchRequest<Roll>(entityName: "Roll")
    }

    @NSManaged public var dateRolled: Date?
    @NSManaged public var presetName: String?
    @NSManaged public var dice: NSSet?
    
    // Convenience computed properties
    
    public var wrappedDateRolled: Date {
        //dateRolled ?? Date.now
        if let date = dateRolled {
            print("Valid date found")
            return date
        } else {
            print("Date invalid")
            return Date.now
        }
    }
    
    public var wrappedPresetName: String {
        presetName ?? ""
    }
    
//    public var wrappedDice: [Die] {
//        let set = dice as? Set<Die> ?? []
//        return set.sorted {
//            $0.numberOfSides.rawValue < $1.numberOfSides.rawValue
//        }
//    }
    
    public var wrappedDice: [Die] {
        get {
            let set = dice as? Set<Die> ?? []
            return set.sorted {
                $0.numberOfSides.rawValue < $1.numberOfSides.rawValue
            }
        }
        
        set {
            dice = NSSet(array: newValue)
        }
    }
    
    var rollTotal: Int {
        Int(wrappedDice.reduce(into: 0, { $0 += $1.result }))
    }
    var modifierTotal: Int {
        Int(wrappedDice.reduce(into: 0, { $0 += $1.modifier }))
    }
    var grandTotal: Int {
        rollTotal + modifierTotal
    }

}

// MARK: Generated accessors for dice
extension Roll {

    @objc(addDiceObject:)
    @NSManaged public func addToDice(_ value: Die)

    @objc(removeDiceObject:)
    @NSManaged public func removeFromDice(_ value: Die)

    @objc(addDice:)
    @NSManaged public func addToDice(_ values: NSSet)

    @objc(removeDice:)
    @NSManaged public func removeFromDice(_ values: NSSet)

}

extension Roll {
    
    // Set each die roll result to zero
    func resetDiceResults() {
        
//        let currentDice = wrappedDice
//        currentDice.indices.forEach {
//            currentDice[$0].result = 0
//        }
//        
//        dice = NSSet(array: currentDice)
        
        let newDice = wrappedDice
        newDice.indices.forEach {
            newDice[$0].result = 0
        }
        wrappedDice = newDice
    }

    // Simulate a roll for each die
    func randomizeDiceResults() {
//        wrappedDice.indices.forEach {
//            wrappedDice[$0].result = Int16(Int.random(in: 1...wrappedDice[$0].numberOfSides.rawValue))
//        }
        
        let newDice = wrappedDice
        newDice.indices.forEach {
            newDice[$0].result = Int16(Int.random(in: 1...newDice[$0].numberOfSides.rawValue))
        }
        wrappedDice = newDice
    }
}

extension Roll : Identifiable {

}
