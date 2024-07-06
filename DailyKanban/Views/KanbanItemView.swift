//
//  KanbanItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct KanbanItemView: View {
    @State var rootKanbanItem: KanbanItem
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(rootKanbanItem.color.gradient)
            .frame(height: 50)
            .overlay(
                HStack(alignment: .center) {
                    UnderlyingKanbanItemView(rootKanbanItem: rootKanbanItem)
                    Button {
                        withAnimation {
                            handleButtonClick()
                        }
                    } label: {
                        Image(systemName: "pencil")
                            .tint(.black)
                    }.padding(.trailing)
                }
            )
    }

    /// TODO: Allow editing of KanbanItems
    private func handleButtonClick() {
        // no-op
    }
}

/// Handles the text part of a kanban view
struct UnderlyingKanbanItemView: View {
    @State var rootKanbanItem: KanbanItem
    
    var body: some View {
        HStack {
            Text(rootKanbanItem.title)
                .font(.title.bold())
            Spacer()
        }
        .padding()
    }
}

#Preview {
    KanbanItemView(rootKanbanItem: StaticProperties.random(withId: 0))
}
