//
//  ViewItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/6/24.
//

import SwiftUI

struct ViewItemView: View {
    @StateObject var item: KanbanItem

    var body: some View {
        VStack {
            Text(item.title)
                .font(.title.bold())
                .padding()
            if let description = item.description {
                Text(description)
                    .font(.subheadline)
                    .padding()
            }
            ForEach(item.todoItems) { todo in
                CheckableTodoItem(todo: todo)
            }
            .padding()
            Spacer()
        }
        .padding()
        .frame(alignment: .top)
    }
}

fileprivate struct CheckableTodoItem: View {
    @ObservedObject var todo: KanbanItem.Todo

    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageString = todo.isComplete ? "checkmark.square" : "square"
            Button {
                todo.isComplete.toggle()
            } label: {
                HStack {
                    Image(systemName: imageString)
                        .tint(.black)
                    Text(todo.description)
                        .tint(.black)
                }
            }
            .frame(minWidth: size.width, alignment: .leading)
        }
    }
}

#Preview {
    ViewItemView(item: StaticProperties.random(withId: 0))
}
