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
    enum CodingKeys: String, CodingKey {
        case color, column, title, todoDescription, ranking, todoItem
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init(context: DataController.shared.persistentContainer.viewContext)

        var container = try decoder.container(keyedBy: CodingKeys.self)
        ranking = try container.decode(Int16.self, forKey: .ranking)
        column = try container.decode(Int16.self, forKey: .column)
        title = try container.decode(String.self, forKey: .title)
        todoItem = try container.decode(Set<PersistableTodoItem>.self, forKey: .todoItem)
        todoDescription  = try container.decodeIfPresent(String.self, forKey: .todoDescription)
        color = try container.decode(String.self, forKey: .color)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(column, forKey: .column)
        try container.encode(title, forKey: .title)
        try container.encode(todoItem, forKey: .todoItem)
        try container.encode(todoDescription, forKey: .todoDescription)
        try container.encode(color, forKey: .color)
        try container.encode(ranking, forKey: .ranking)
    }
}
