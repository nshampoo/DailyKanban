//
//  ContentView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var board = KanbanBoard(columns: KanbanColumn.sampleKanbanStart)
    @State var selectedTab: Int = 2
    @State var trashCanSelected: Bool = false
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 10) {
            topTabBar()
            primaryScroller()
            customTabBar()
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /// If we are dragging at all, consider it so
        .dropDestination(for: KanbanItem.self) { _, _ in
            return false
        } isTargeted: { trashCanSelected = $0 }
        .background(.gray.opacity(0.1))
    }
    
    
    @ViewBuilder
    func primaryScroller() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(board.listedColumns(), id: \.id) { column in
                    underlyingScroller(column: column)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.3)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: Binding($selectedTab))
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollClipDisabled()
        .onChange(of: selectedTab) { _, newValue in
            board.currentlySelectedColumnId = newValue
        }
    }

    @ViewBuilder
    func underlyingScroller(column: KanbanColumn) -> some View {
        ScrollView(.vertical) {
            ForEach(column.items.values.sorted(), id: \.title) { item in
                KanbanItemView(rootKanbanItem: item)
                    .padding()
                    .draggable(item)
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func topTabBar() -> some View {
        Text("Daily Kanban")
            .font(.largeTitle.bold())
            .padding(5)
            .background(.gray.opacity(0.3), in: .capsule)
    }
    
    @ViewBuilder
    func customTabBar() -> some View {
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
                        withAnimation(.spring) {
                            board.currentlySelectedColumnId = column.id
                            selectedTab = column.id
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
                    let capsuleWidth = size.width / CGFloat(board.columns.count)
                    
                    Capsule()
                        .fill(scheme == .dark ? .black : .white)
                        .frame(width: capsuleWidth)
                        .offset(x: (Double(selectedTab) / Double(board.columns.count - 1)) * (size.width - capsuleWidth))
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
                let image = trashCanSelected ? "trash" : "plus"
                let tint: Color = trashCanSelected ? .red : .black
                Image(systemName: image)
                    .tint(tint)
            }
            .dropDestination(for: KanbanItem.self) { items, _ in
                guard let item = items.first else { return false }
                board.removeItem(withItemId: item.id)
                return true
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
