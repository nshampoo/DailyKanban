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
    /// This can be how we iterate over all the items, how we associate different items into different places
    let id: Int

    let title: String
    
    let description: String
    
    let color: Color
    
    /// This is only for testing
    static let possibleTites: [String] = ["Clean Dishes", "Cry in a Corner", "Say hi to Girlfriend", "Read a Book", "Lay on the Floor"]
    
    static let description: String =
    """
    We need to be able to cite a lot of information here
    1. This could be subtasks
    2. Or this could just be other things that need to be done
    """
    
    /// The time in hours beetween this item coming back
    let retention: Double?
    
    public init(id: Int, title: String, description: String, retention: Double? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.retention = retention
        self.color = [Color.purple, .green, .red, .blue].randomElement() ?? .white
    }

    static func random(withId id: Int) -> KanbanItem {
        let item = KanbanItem(id: id, title: KanbanItem.possibleTites.randomElement() ?? "Failed to get random?", description: description)
        
        return item
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
        CodableRepresentation(for: KanbanItem.self, contentType: .content)
    }
}

extension KanbanItem: Codable {
    convenience init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let id = try container.decode(Int.self)
        let title = try container.decode(String.self)
        let description  = try container.decode(String.self)
        let retention = try container.decodeIfPresent(Double.self)
        
        self.init(id: id, title: title, description: description, retention: retention)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(id)
        try container.encode(title)
        try container.encode(description)
    }
}
