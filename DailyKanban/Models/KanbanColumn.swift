//
//  KanbanColumn.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import Foundation

class KanbanColumn: ObservableObject {
    let id: Int
    /// I'm imagining we can save items that are in retention periods into some "hidden" column. Perhaps this is visible or not, but doesn't matter for now
    var isVisible: Bool = true
    
    var name: String
    @Published var items: [Int:KanbanItem] = [:]

    public init(id: Int, isVisible: Bool, name: String, items: [Int : KanbanItem]) {
        self.id = id
        self.isVisible = isVisible
        self.name = name
        self.items = items
    }
    
    func addItem(_ item: KanbanItem) {
        items[item.id] = item
    }
    
    @discardableResult
    func removeItem(withId id: Int) throws -> KanbanItem {
        guard let item = items.removeValue(forKey: id) else { throw KanbanErrors.invalidParameters }
        
        return item
    }
}

/// Extremely simple comparability, should not be used longterm
extension KanbanColumn: Comparable {
    static func < (lhs: KanbanColumn, rhs: KanbanColumn) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: KanbanColumn, rhs: KanbanColumn) -> Bool {
        lhs.id == rhs.id
    }
}
