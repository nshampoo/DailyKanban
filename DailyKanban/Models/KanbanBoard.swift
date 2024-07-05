//
//  KanbanBoard.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import Foundation



/// Open Questions:
/// Do I want the kanban board to have all the information I have in nice APIs
/// - or would I rather have "users" access the columns and their associated KanbanItems directly
///
///
/// In theory this whole model is decodable, so we can save it in some json, to be accessed
class KanbanBoard: ObservableObject {
    var globalItemIdCounter: Int = 0
    @Published var columns: [Int:KanbanColumn] = [:]
    @Published var currentlySelectedColumn: KanbanColumn
    
    var currentlySelectedColumnId = 2 {
        didSet {
            currentlySelectedColumn = columns[currentlySelectedColumnId] ?? .todayColumn
        }
    }
    
    /// API to allow UI to get a list of items for a certain column
    func items(forColumnWithId id: Int? = nil) throws -> [Int: KanbanItem] {
        let id = id ?? currentlySelectedColumnId
        guard let column = columns[id] else { throw KanbanErrors.invalidParameters }

        return column.items
    }

    func addItem(_ item: KanbanItem, toColumn: Int) {
        columns[toColumn]?.addItem(item)
        
        print("asdf")
    }
    
    func moveItem(withItemId itemId: Int, fromColumn: Int, toColumn: Int) throws {
        guard let item = try columns[fromColumn]?.removeItem(withId: itemId) else { throw KanbanErrors.invalidParameters }
        
        addItem(item, toColumn: toColumn)
    }
    
    func moveItem(withItemId itemId: Int, toColumn: Int) {
        var fromColumnId: Int?
        for column in columns {
            if column.value.items.contains(where: { $0.key == itemId }) {
                fromColumnId = column.key
                break
            }
        }
        
        do {
            try moveItem(withItemId: itemId, fromColumn: fromColumnId ?? 0, toColumn: toColumn)
        } catch {
            assertionFailure("This should never happen")
        }
    }
    
    /// This is a test init, that allows me to have sample data
    init(columns: [Int : KanbanColumn]) {
        self.columns = columns
        self.currentlySelectedColumn = .todayColumn
    }

    func listedColumns() -> [KanbanColumn] {
        columns.values.sorted()
    }

}

enum KanbanErrors: Error {
    case invalidParameters
}
