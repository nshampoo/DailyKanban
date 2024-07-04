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
struct KanbanBoard {
    var globalItemIdCounter: Int = 0
    var columns: [Int:KanbanColumn] = [:]
    var currentlySelectedColumnId = 2
    
    /// API to allow UI to get a list of items for a certain column
    func items(forColumnWithId id: Int? = nil) throws -> [Int: KanbanItem] {
        let id = id ?? currentlySelectedColumnId
        guard let column = columns[id] else { throw KanbanErrors.invalidParameters }

        return column.items
    }

    mutating func addItem(_ item: KanbanItem, toColumn: Int) {
        columns[toColumn]?.addItem(item)
        
        print("asdf")
    }
    
    mutating func moveItem(withItemId itemId: Int, fromColumn: Int, toColumn: Int) throws {
        guard var fromColumn = columns[fromColumn] else { throw KanbanErrors.invalidParameters }
        
        let item = try fromColumn.removeItem(withId: itemId)
        
        addItem(item, toColumn: toColumn)
    }
    
    /// This is a test init, that allows me to have sample data
    init(columns: [Int : KanbanColumn]) {
        self.columns = columns
    }

    func listedColumns() -> [KanbanColumn] {
        columns.values.sorted()
    }
    
    func currentlySelectedColumn() -> KanbanColumn {
        columns[currentlySelectedColumnId] ?? .doneColumn
    }
}

enum KanbanErrors: Error {
    case invalidParameters
}
