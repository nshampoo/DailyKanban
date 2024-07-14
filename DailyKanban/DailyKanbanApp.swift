//
//  DailyKanbanApp.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

@main
struct DailyKanbanApp: App {
    @StateObject private var dataController = DataController.shared
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<PersistableKanbanItem>

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(KanbanBoard(items: items.sorted(), moc: moc, dataController: dataController))
                .environment(\.managedObjectContext,
                              dataController.persistentContainer.viewContext)
        }
    }
}
