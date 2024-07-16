//
//  PersistableTodoItem+CoreDataProperties.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/14/24.
//
//

import Foundation
import CoreData


extension PersistableTodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistableTodoItem> {
        return NSFetchRequest<PersistableTodoItem>(entityName: "PersistableTodoItem")
    }

    @NSManaged public var isComplete: Bool
    @NSManaged public var desc: String
    @NSManaged public var order: Int16
}

extension PersistableTodoItem: Identifiable { }

extension PersistableTodoItem: Comparable {
    public static func < (lhs: PersistableTodoItem, rhs: PersistableTodoItem) -> Bool {
        lhs.order < rhs.order
    }
}

