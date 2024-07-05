//
//  ContentView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var board = KanbanBoard(columns: KanbanColumn.sampleKanbanStart)
    @ObservedObject var currentColumn = KanbanColumn.todayColumn
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 15) {
            Scroller()
            CustomTabBar()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.1))
    }
        
    @ViewBuilder
    func Scroller() -> some View {
        ScrollView {
            Text("Daily Kanban")
                .font(.largeTitle.bold())
                .padding(5)
                .background(.gray.opacity(0.3), in: .capsule)
            ForEach(board.currentlySelectedColumn.items.values.sorted(), id: \.title) { item in
                KanbanItemView(rootKanbanItem: item)
                    .padding()
                    .draggable(item)
            }
        }
    }

    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(board.listedColumns(), id: \.name) { column in
                    HStack(spacing: 10) {
                        Text(column.name)
                            .font(.callout)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            board.currentlySelectedColumnId = column.id
                        }
                    }
                    .dropDestination(for: KanbanItem.self) { items, _ in
                        guard let item = items.first else { return false }
                        board.moveItem(withItemId: item.id, toColumn: column.id)
                        return true
                    }
                }
                
            }/// Bakground to show which one is selected
            .background {
                GeometryReader {
                    let size = $0.size
                    let capsuleWidth = size.width / CGFloat(board.listedColumns().count)
                    
                    Capsule()
                        .fill(scheme == .dark ? .black : .white)
                        .frame(width: capsuleWidth)
                        .offset(x: Double(board.currentlySelectedColumnId / board.columns.count) * (size.width - capsuleWidth))
                }
            }
            .background(.gray.opacity(0.2), in: .capsule)
            .padding(.leading, 15)
            
            Button {
                /// Somehow this isn't adding an item?
                /// Using breakpoints its adding the item to the correct column as expected
                board.addItem(KanbanItem.random(withId: board.globalItemIdCounter), toColumn: board.currentlySelectedColumnId)
                board.globalItemIdCounter += 1
            } label: {
                Image(systemName: "plus")
                    .tint(.black)
            }
            .padding(10)
            .background(.gray.opacity(0.2), in: .capsule)
            .padding(5)
        }
        
    }
}

#Preview {
    ContentView()
}
