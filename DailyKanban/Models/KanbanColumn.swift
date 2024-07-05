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
    
    static let todoColumn = KanbanColumn(id: 0, isVisible: true, name: "ToDo", items: [:])
    static let waitingColumn = KanbanColumn(id: 1, isVisible: true, name: "Waiting", items: [:])
    static let todayColumn = KanbanColumn(id: 2, isVisible: true, name: "Today", items: [:])
    static let inProgressColumn = KanbanColumn(id: 3, isVisible: true, name: "Doing", items: [:])
    static let doneColumn = KanbanColumn(id: 4, isVisible: true, name: "Done", items: [:])
    static let retentionColumn = KanbanColumn(id: 5, isVisible: false, name: "Retention", items: [:])
    static let sampleKanbanStart: [Int:KanbanColumn] = [
        0: todoColumn,
        1: waitingColumn,
        2: todayColumn,
        3: inProgressColumn,
        4: doneColumn,
    ]
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
