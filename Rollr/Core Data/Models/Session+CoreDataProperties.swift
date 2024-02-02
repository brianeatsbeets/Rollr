//
//  Session+CoreDataProperties.swift
//  Rollr
//
//  Created by Aguirre, Brian P. on 2/2/24.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String?
    @NSManaged public var rolls: NSSet?
    
    var wrappedDateCreated: Date {
        dateCreated ?? Date.now
    }
    
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedRolls: [Roll] {
        get {
            let set = rolls as? Set<Roll> ?? []
            return set.sorted {
                $0.wrappedDateRolled < $1.wrappedDateRolled
            }
        }
        
        set {
            rolls = NSSet(array: newValue)
        }
    }

}

// MARK: Generated accessors for rolls
extension Session {

    @objc(addRollsObject:)
    @NSManaged public func addToRolls(_ value: Roll)

    @objc(removeRollsObject:)
    @NSManaged public func removeFromRolls(_ value: Roll)

    @objc(addRolls:)
    @NSManaged public func addToRolls(_ values: NSSet)

    @objc(removeRolls:)
    @NSManaged public func removeFromRolls(_ values: NSSet)

}

extension Session : Identifiable {

}
