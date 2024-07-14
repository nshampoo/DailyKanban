//
//  PersistableKanbanItem+CoreDataProperties.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/14/24.
//
//

import Foundation
import CoreData
import UniformTypeIdentifiers
import SwiftUI


extension PersistableKanbanItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistableKanbanItem> {
        return NSFetchRequest<PersistableKanbanItem>(entityName: "PersistableKanbanItem")
    }

    @NSManaged public var color: String
    @NSManaged public var column: Int16
    @NSManaged public var title: String
    @NSManaged public var todoDescription: String?
    @NSManaged public var ranking: Int16
    @NSManaged public var todoItem: Array<PersistableTodoItem>
    
    public func wrappedColor() -> Color {
        StaticProperties.PickableColors(rawValue: color)?.asColor() ?? .gray
    }
}

// MARK: Generated accessors for todoItem
extension PersistableKanbanItem {

    @objc(insertObject:inTodoItemAtIndex:)
    @NSManaged public func insertIntoTodoItem(_ value: PersistableTodoItem, at idx: Int)

    @objc(removeObjectFromTodoItemAtIndex:)
    @NSManaged public func removeFromTodoItem(at idx: Int)

    @objc(insertTodoItem:atIndexes:)
    @NSManaged public func insertIntoTodoItem(_ values: [PersistableTodoItem], at indexes: NSIndexSet)

    @objc(removeTodoItemAtIndexes:)
    @NSManaged public func removeFromTodoItem(at indexes: NSIndexSet)

    @objc(replaceObjectInTodoItemAtIndex:withObject:)
    @NSManaged public func replaceTodoItem(at idx: Int, with value: PersistableTodoItem)

    @objc(replaceTodoItemAtIndexes:withTodoItem:)
    @NSManaged public func replaceTodoItem(at indexes: NSIndexSet, with values: [PersistableTodoItem])

    @objc(addTodoItemObject:)
    @NSManaged public func addToTodoItem(_ value: PersistableTodoItem)

    @objc(removeTodoItemObject:)
    @NSManaged public func removeFromTodoItem(_ value: PersistableTodoItem)

    @objc(addTodoItem:)
    @NSManaged public func addToTodoItem(_ values: NSOrderedSet)

    @objc(removeTodoItem:)
    @NSManaged public func removeFromTodoItem(_ values: NSOrderedSet)

}

extension PersistableKanbanItem : Identifiable { }

/// Extremely simple comparability, should not be used longterm
extension PersistableKanbanItem: Comparable {
    public static func < (lhs: PersistableKanbanItem, rhs: PersistableKanbanItem) -> Bool {
        lhs.id < rhs.id
    }
    
    public static func == (lhs: PersistableKanbanItem, rhs: PersistableKanbanItem) -> Bool {
        lhs.id == rhs.id
    }
}

//extension PersistableKanbanItem: Transferable {
//    public static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(for: PersistableKanbanItem.self, contentType: .image)
//    }
//}
