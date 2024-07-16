//
//  KanbanBoard.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import Foundation
import CoreData



/// Open Questions:
/// Do I want the kanban board to have all the information I have in nice APIs
/// - or would I rather have "users" access the columns and their associated KanbanItems directly
///
///
/// In theory this whole model is decodable, so we can save it in some json, to be accessed
class KanbanBoard: ObservableObject {
    let dataController: DataController
    var globalItemIdCounter: Int {
        get {
            /// Hello future me who is going to be pissed that I let a potential integer overflow happen
            ///
            /// This is past you saying that I don't care have a good day
            let returnValue = UserDefaults.standard.integer(forKey: "currentItemIdCounter")
            UserDefaults.standard.setValue(returnValue + 1, forKey: "currentItemIdCounter")
            return returnValue
        }
    }
    @Published var columns: [KanbanColumn] = []
    @Published var currentlySelectedColumn: KanbanColumn
    @Published var currentlySelectedItems: [PersistableKanbanItem]
    
    var currentlySelectedColumnId = 2 {
        didSet {
            currentlySelectedColumn = columns[currentlySelectedColumnId]
            currentlySelectedItems = currentlySelectedColumn.items.sorted()
        }
    }
    
    /// API to allow UI to get a list of items for a certain column
    func items(forColumnWithId id: Int? = nil) throws -> [PersistableKanbanItem] {
        let id = id ?? currentlySelectedColumnId
        
        return columns[id].items.sorted()
    }
    
    func addItem(_ item: PersistableKanbanItem) {
        DataController.shared.save()
        columns[Int(item.column)].addItem(item)
        
        updateItemsIfNeeded(forColumn: Int(item.column))
    }
    
    func moveItem(withItemId itemId: Int, fromColumn: Int, toColumn: Int) throws {
        let item: PersistableKanbanItem
        do {
            item = try columns[fromColumn].removeItem(withId: itemId)
        } catch {
            throw error
        }
        item.column = Int16(toColumn)
        updateItemsIfNeeded(forColumn: fromColumn)
        
        addItem(item)
    }
    
    func moveItem(withItemId itemId: Int, toColumn: Int) {
        guard let fromColumnId = findColumnForItem(withId: itemId) else { return }
        
        do {
            try moveItem(withItemId: itemId, fromColumn: fromColumnId, toColumn: toColumn)
        } catch {
            assertionFailure("This should never happen")
        }
    }
    
    func removeItem(withItemId itemId: Int) {
        guard let fromColumnId = findColumnForItem(withId: itemId) else { return }
        do {
            let item = try columns[fromColumnId].removeItem(withId: itemId)
            removeItemFromCoreData(item)
        } catch {
            assertionFailure("Removing an item that doesn't exist?")
        }
        
        
        updateItemsIfNeeded(forColumn: fromColumnId)
    }
    
    /// This is a test init, that allows me to have sample data
    init(dataController: DataController) {
        let startingColumns = StaticProperties.sampleKanbanStart
        self.currentlySelectedColumn = startingColumns.first!

        for item in dataController.fetchItems() {
            startingColumns[Int(item.column)].addItem(item)
        }
        
        currentlySelectedItems = startingColumns[2].items
        self.columns = startingColumns
        self.dataController = dataController
    }
    
    func listedColumns() -> [KanbanColumn] {
        columns.sorted()
    }
    
    func updateItemsIfNeeded(forColumn: Int) {
        DataController.shared.save()

        guard forColumn == currentlySelectedColumnId else { return }
        do {
            currentlySelectedItems = try items()
        } catch {
            assertionFailure("no")
        }
    }
    
    private func findColumnForItem(withId id: Int) -> Int? {
        var fromColumnId: Int?
        for column in columns {
            if column.items.contains(where: { $0.ranking == id }) {
                fromColumnId = Int(column.id)
                break
            }
        }
        return fromColumnId
    }
    
    private func removeItemFromCoreData(_ item: PersistableKanbanItem) {
        dataController.delete(item: item)
    }
}

enum KanbanErrors: Error {
    case invalidParameters
}
