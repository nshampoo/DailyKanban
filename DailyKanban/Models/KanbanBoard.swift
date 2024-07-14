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
    let moc: NSManagedObjectContext
    let dataController: DataController
    var globalItemIdCounter: Int = 0
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
        saveItemToCoreData(item)
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
    init(items: [PersistableKanbanItem], moc: NSManagedObjectContext, dataController: DataController) {
        let startingColumns = StaticProperties.sampleKanbanStart
        self.currentlySelectedColumn = startingColumns.first!
        
        for item in items {
            startingColumns[Int(item.column)].addItem(item)
        }
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        currentlySelectedItems = startingColumns[2].items
        self.columns = startingColumns
        self.moc = moc
        self.dataController = dataController
    }
    
    func listedColumns() -> [KanbanColumn] {
        columns.sorted()
    }
    
    func updateItemsIfNeeded(forColumn: Int) {
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
    
    private func saveItemToCoreData(_ item: PersistableKanbanItem) {
        Task {
            do {
                dataController.save()
//                try moc.save()
            } catch {
                print("Failed to save core data? Error: \(error)")
            }
        }
    }
    
    private func removeItemFromCoreData(_ item: PersistableKanbanItem) {
        dataController.delete(item: item)
//        moc.delete(item)
    }
}

enum KanbanErrors: Error {
    case invalidParameters
}
