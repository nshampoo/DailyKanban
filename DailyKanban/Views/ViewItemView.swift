//
//  ViewItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/6/24.
//

import SwiftUI

struct ViewItemView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var item: PersistableKanbanItem

    /// When we dismiss this view, if we have a kanban Item we want to share back, we utilzie escapingKanbanItem to do so
    /// In theory any "user" could make this a different function if they wanted too. However in practice this just saves to the board
    var escapingDeletionTask: (_ shouldDelete: Bool) -> Void

    var body: some View {
        NavigationStack {
            VStack {
                Text(item.title)
                    .font(.title.bold())
                    .padding()
                if let description = item.todoDescription {
                    Text(description)
                        .font(.subheadline)
                        .padding()
                }
                ForEach(item.todoItem.sorted()) { todo in
                    CheckableTodoItem(todo: todo)
                }
                .padding()
                Spacer()
            }
            .padding()
            .frame(alignment: .top)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        escapingDeletionTask(true)
                        dismiss()
                    } label: {
                        Image(systemName: "trash.circle")
                            .tint(.black)
                            .font(.title)
                    }
                    .padding()
                }
            }
        }
    }
}

fileprivate struct CheckableTodoItem: View {
    @ObservedObject var todo: PersistableTodoItem

    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageString = todo.isComplete ? "checkmark.square" : "square"
            Button {
                todo.isComplete.toggle()
                /// Any time we update a TODO we need to save the coredata
                DataController.shared.save()
            } label: {
                HStack {
                    Image(systemName: imageString)
                        .tint(.black)
                    Text(todo.desc)
                        .tint(.black)
                }
            }
            .frame(minWidth: size.width, alignment: .leading)
        }
    }
}

//#Preview {
//    ViewItemView(item: StaticProperties.random(withId: 0), escapingDeletionTask: { _ in return })
//}
