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
    @State private var color: StaticProperties.PickableColors = .Gray
    
    /// Stepper
    @State var numTodos: Int = 0
    private let maxTodos: Int
    @State var todos: [String]
    
    /// When we dismiss this view, if we have a kanban Item we want to share back, we utilzie escapingKanbanItem to do so
    /// In theory any "user" could make this a different function if they wanted too. However in practice this just saves to the board
    var escapingKanbanItem: (_ item: KanbanItem) -> Void
    
    public init(numTodos: Int = 0, maxTodos: Int = 10, escapingKanbanItem: @escaping (_ item: KanbanItem) -> Void) {
        
        self.numTodos = numTodos
        self.maxTodos = maxTodos
        todos = [String](repeating:"", count: maxTodos)
        
        self.escapingKanbanItem = escapingKanbanItem
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Title", text: $title)
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
            .tint(.gray)
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
                color = .Gray
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
                guard let kanbanItem = KanbanItem(checkingForEmptyStrings: title,
                                                  description: description,
                                                  color: color.asColor(),
                                                  todos: todos,
                                                  maxTodos: numTodos) else { return }
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
