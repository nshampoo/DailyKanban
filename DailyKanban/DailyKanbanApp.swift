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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(KanbanBoard(dataController: dataController))
                .environment(\.managedObjectContext, dataController.persistentContainer.viewContext)
        }
    }
}
