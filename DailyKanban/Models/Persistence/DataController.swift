//
//  DataController.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/14/24.
//

import Foundation
import CoreData

// Define an observable class to encapsulate all Core Data-related functionality.
class DataController: ObservableObject {
    static let shared = DataController()
    
    // Create a persistent container as a lazy variable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container’s initializer.
        let container = NSPersistentContainer(name: "Model")
        
        // Load any persistent stores, which creates a store if none exists.
        container.loadPersistentStores { _, error in
            if let error {
                // Handle the error appropriately. However, it's useful to use
                // `fatalError(_:file:line:)` during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
        
    private init() { }
}

extension DataController {
    // Add a convenience method to commit changes to the store.
    func save() {
        // Verify that the context has uncommitted changes.
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            // Attempt to save changes.
            try persistentContainer.viewContext.save()
        } catch {
            // Handle the error appropriately.
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func delete(item: PersistableKanbanItem) {
        for child in item.todoItem {
            persistentContainer.viewContext.delete(child)
        }
        persistentContainer.viewContext.delete(item)
        save()
    }
    
    func fetchItems() -> [PersistableKanbanItem] {
        var persistableKanbanItems: [PersistableKanbanItem] = []
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PersistableKanbanItem")
            let results = try persistentContainer.viewContext.fetch(request)
            for result in results {
                if let result = result as? PersistableKanbanItem {
                    persistableKanbanItems.append(result)
                }
            }
        } catch {
            assertionFailure("Failed to fetch items?")
        }
        
        return persistableKanbanItems
    }
}
