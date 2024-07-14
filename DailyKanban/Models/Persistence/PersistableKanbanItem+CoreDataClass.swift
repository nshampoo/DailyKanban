//
//  PersistableKanbanItem+CoreDataClass.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/14/24.
//
//

import Foundation
import CoreData

@objc(PersistableKanbanItem)
public class PersistableKanbanItem: NSManagedObject, Codable {
    public required init(from decoder: Decoder) throws {
        super.init(context: DataController.shared.persistentContainer.viewContext)

        var container = try decoder.unkeyedContainer()
        ranking = try container.decode(Int16.self)
        column = try container.decode(Int16.self)
        title = try container.decode(String.self)
        todoItem = Set<PersistableTodoItem>()
        //try container.decode([Todo].self)
        todoDescription  = try container.decodeIfPresent(String.self)
        color = try container.decode(String.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(column)
        try container.encode(title)
//        try container.encode(todoItems)
        try container.encode(todoDescription)
        try container.encode(color)
        try container.encode(ranking)
    }
}
