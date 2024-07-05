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

struct KanbanItem {
    /// This can be how we iterate over all the items, how we associate different items into different places
    let id: Int

    var title: String = "Clean Dishes"
    
    /// This is only for testing
    static let possibleTites: [String] = ["Clean Dishes", "Cry in a Corner", "Say hi to Girlfriend", "Read a Book", "Lay on the Floor"]
    
    var description: String =
    """
    We need to be able to cite a lot of information here
    1. This could be subtasks
    2. Or this could just be other things that need to be done
    """
    
    /// The time in hours beetween this item coming back
    var retention: Double? = 30 * 24
    
    /// Again this is only for testing, I imagine in a perfect world when this app is done we have a separate view that would edit these, and if we choose mutation or creation of a new item
    mutating func mutate() {
        title = KanbanItem.possibleTites.randomElement() ?? "Failed to get random?"
    }

    static func random(withId id: Int) -> KanbanItem {
        let item = KanbanItem(id: id, title: KanbanItem.possibleTites.randomElement() ?? "Failed to get random?")
        
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

extension KanbanItem: Transferable, Codable, Identifiable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: KanbanItem.self, contentType: .content)
    }
}
