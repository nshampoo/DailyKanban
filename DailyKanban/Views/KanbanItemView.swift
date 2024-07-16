//
//  KanbanItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct KanbanItemView: View {
    @State var rootKanbanItem: PersistableKanbanItem
    @State var color: Color

    public init(rootKanbanItem: PersistableKanbanItem) {
        self.rootKanbanItem = rootKanbanItem
        self.color = rootKanbanItem.wrappedColor()
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color.gradient)
            .frame(height: 50)
            .overlay(
                UnderlyingKanbanItemView(title: $rootKanbanItem.title, isEditable: false)
            )
    }
}

struct KanbanBuildingItemView: View {
    @Binding var title: String
    @Binding var color: StaticProperties.PickableColors

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color.asColor().gradient)
            .frame(height: 50)
            .overlay(
                UnderlyingKanbanItemView(title: $title, isEditable: true)
            )
    }
}

/// Handles the text part of a kanban view
struct UnderlyingKanbanItemView: View {
    @Binding var title: String
    @State var isEditable: Bool
    
    var body: some View {
        HStack {
            if isEditable {
                TextField("Title", text: $title)
                    .font(.title.bold())
            } else {
                Text(title)
                    .font(.title.bold())
            }
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    KanbanItemView(rootKanbanItem: StaticProperties.random(withId: 0))
//}
