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
    @Published var items: [PersistableKanbanItem] = []

    public init(id: Int, isVisible: Bool, name: String, items: [PersistableKanbanItem]) {
        self.id = id
        self.isVisible = isVisible
        self.name = name
        self.items = items
    }
    
    func addItem(_ item: PersistableKanbanItem) {
        items.append(item)
        items = items.sorted()
    }
    
    @discardableResult
    func removeItem(withId id: Int) throws -> PersistableKanbanItem {
        var returnableItem: PersistableKanbanItem?
        items.removeAll(where: {
            if $0.ranking == Int16(id) {
                returnableItem = $0
                return true
            }
            return false
        })
        guard let item = returnableItem else { throw KanbanErrors.invalidParameters }

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
