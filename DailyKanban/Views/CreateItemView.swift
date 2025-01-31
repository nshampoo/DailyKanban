//
//  CreateItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/6/24.
//

import SwiftUI

///https://blog.logrocket.com/building-forms-swiftui-comprehensive-guide/
struct CreateItemNavigationView: View {
    @Environment(\.dismiss) var dismiss
    
    /// Strings
    @State private var title: String = ""
    @State private var description: String = ""
    
    /// Colors
    @State private var color: StaticProperties.PickableColors = .Blue
    
    /// Stepper
    @State var numTodos: Int = 0
    private let maxTodos: Int
    @State var todos: [String]
    
    /// When we dismiss this view, if we have a kanban Item we want to share back, we utilzie escapingKanbanItem to do so
    /// In theory any "user" could make this a different function if they wanted too. However in practice this just saves to the board
    var escapingKanbanItem: (_ item: PersistableKanbanItem) -> Void
    
    public init(numTodos: Int = 0, maxTodos: Int = 10, escapingKanbanItem: @escaping (_ item: PersistableKanbanItem) -> Void) {
        
        self.numTodos = numTodos
        self.maxTodos = maxTodos
        todos = [String](repeating:"", count: maxTodos)
        
        self.escapingKanbanItem = escapingKanbanItem
    }
    
    var body: some View {
        NavigationStack {
            KanbanBuildingItemView(title: $title, color: $color)
                .padding([.leading, .trailing, .bottom])
            Form {
                Section() {
                    TextField("Description", text: $description)
                }
                .padding(.horizontal)
                
                Section(header: Text("Customize")) {
                    Picker(selection: $color, label: Text("highlighter")) {
                        ForEach(StaticProperties.PickableColors.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                Section(header: Text("Sub-Tasks")) {
                    LazyVStack {
                        Stepper("Number: \(numTodos)", value: $numTodos.animation(), in: 0...maxTodos)
                        ForEach(0 ..< 10) {
                            if $0 < numTodos {
                                TextField("Todo", text: $todos[$0])
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                customHeaderToolbar
            }
        }
    }

    @ToolbarContentBuilder
    private var customHeaderToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .tint(.black)
                    .font(.title)
            }
        }
        ToolbarItem(placement: .principal) {
            Button {
                title = ""
                description = ""
                color = .Blue
                numTodos = 0
                todos = [String](repeating:"", count: 10)
            } label: {
                Image(systemName: "eraser.line.dashed")
                    .tint(.black)
                    .font(.title)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                guard !title.isEmpty,
                        numTodos <= maxTodos else { return }
                let moc = DataController.shared.persistentContainer.viewContext
                let kanbanItem = PersistableKanbanItem(context: moc)
                kanbanItem.title = title
                kanbanItem.todoDescription = description
                kanbanItem.color = color.rawValue
                var persistableTodos: [PersistableTodoItem] = []
                var numTodos = Int16(0)
                for todo in todos {
                    guard !todo.isEmpty else { break }

                    let persistableTodo = PersistableTodoItem(context: moc)
                    persistableTodo.isComplete = false
                    persistableTodo.desc = todo
                    persistableTodo.order = numTodos
                    persistableTodos.append(persistableTodo)
                    numTodos += 1
                }
                kanbanItem.todoItem = Set(persistableTodos)
                escapingKanbanItem(kanbanItem)
                dismiss()
            } label: {
                Image(systemName: "plus.circle")
                    .tint(.black)
                    .font(.title)
            }
        }
    }
}

#Preview {
    CreateItemNavigationView(numTodos: 2, escapingKanbanItem: { _ in return })
}
