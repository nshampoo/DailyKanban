//
//  ContentView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    KanbanItemView()
                        .padding()
                    KanbanItemView()
                        .padding()
                    KanbanItemView()
                        .padding()
                    KanbanItemView()
                        .padding()
                    KanbanItemView()
                        .padding()
                    KanbanItemView()
                        .padding()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text("To Do")
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("To Do") {
                        print("Pressed")
                    }
                    Button("Waiting") {
                        print("Pressed")
                    }
                    Button("Today") {
                        print("Pressed")
                    }
                    Button("In Progress") {
                        print("Pressed")
                    }
                    Button("Done") {
                        print("Pressed")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
