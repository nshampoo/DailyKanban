//
//  KanbanItem.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

/// This represents the core model of what a TODO item is...


final class KanbanItem: ObservableObject {
    final public class Todo: ObservableObject, Identifiable {
        @Published var isComplete: Bool
        var description: String
        
        public init(isComplete: Bool, description: String) {
            self.isComplete = isComplete
            self.description = description
        }
    }

    /// This can be how we iterate over all the items, how we associate different items into different places
    var id: Int

    var title: String
    
    @Published var todoItems: [Todo]
    
    var description: String?
    
    var color: StaticProperties.PickableColors
    
    /// The time in hours beetween this item coming back
    /// TODO: Implement retention
    var retention: Double?
    
    public init(id: Int, title: String, todoItems: [Todo], description: String?, color: StaticProperties.PickableColors, retention: Double?) {
        self.id = id
        self.title = title
        self.todoItems = todoItems
        self.description = description
        self.color = color
        self.retention = retention
    }
}

/// Extremely simple comparability, should not be used longterm
extension KanbanItem: Comparable {
    static func < (lhs: KanbanItem, rhs: KanbanItem) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: KanbanItem, rhs: KanbanItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension KanbanItem: Transferable, Identifiable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: KanbanItem.self, contentType: .image)
    }
}

extension KanbanItem: Codable {
    convenience init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let id = try container.decode(Int.self)
        let title = try container.decode(String.self)
        let todoItems = try container.decode([Todo].self)
        let description  = try container.decodeIfPresent(String.self)
        /// TODO: Make Color Codable
        ///  let color = try container.decode(Color.self)
        let retention = try container.decodeIfPresent(Double.self)
        
        self.init(id: id,
                  title: title,
                  todoItems: todoItems,
                  description: description,
                  color: StaticProperties.PickableColors.randomElement(),
                  retention: retention)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(id)
        try container.encode(title)
        try container.encode(todoItems)
        try container.encode(description)
        /// TODO: Make Color Encodable
        try container.encode(retention)
    }
}

extension KanbanItem {
    convenience init?(checkingForEmptyStrings title: String, description: String, color: StaticProperties.PickableColors, todos: [String], maxTodos: Int) {
        guard !title.isEmpty else { return nil }
        
        let description = description.isEmpty ? nil : description
        
        var constructedTodos: [Todo] = []
        for (i, todo) in todos.enumerated() where !todo.isEmpty && i < maxTodos {
            constructedTodos.append(.init(isComplete: false, description: todo))
        }
        
        self.init(id: 0, title: title, todoItems: constructedTodos, description: description, color: color, retention: nil)
    }
}

extension KanbanItem.Todo: Codable {
    convenience init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let isComplete = try container.decode(Bool.self)
        let description = try container.decode(String.self)
        
        self.init(isComplete: isComplete, description: description)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(isComplete)
        try container.encode(description)
    }
}
