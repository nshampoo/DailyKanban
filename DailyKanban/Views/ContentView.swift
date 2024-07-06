//
//  ContentView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var board = KanbanBoard(columns: StaticProperties.sampleKanbanStart)
    @State var selectedTab: Int = 2
    @State var trashCanSelected: Bool = false
    @State var isCreatingItem: Bool = false
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(spacing: 10) {
            topTabBar()
            primaryScroller()
                .sheet(isPresented: Binding(projectedValue: $isCreatingItem), onDismiss: {
                    return
                }, content: { 
                    CreateItemNavigationView(escapingKanbanItem: addItem)
                        .frame(alignment: .bottom)
                })
            customTabBar()
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        /// If we are dragging at all, consider it so
        .dropDestination(for: KanbanItem.self) { _, _ in
            return false
        } isTargeted: { trashCanSelected = $0 }
        .background(.gray.opacity(0.2))
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
        .overlay(alignment: .bottomTrailing) {
            Button {
                /// TODO AddItem view
                isCreatingItem = true
//                board.addItem(StaticProperties.random(withId: board.globalItemIdCounter), toColumn: board.currentlySelectedColumnId)
//                board.globalItemIdCounter += 1
            } label: {
                let image = trashCanSelected ? "trash" : "plus.circle"
                let tint: Color = trashCanSelected ? .red : .black
                Image(systemName: image)
                    .tint(tint)
                    .font(.largeTitle)
            }
            .dropDestination(for: KanbanItem.self) { items, _ in
                guard let item = items.first else { return false }
                board.removeItem(withItemId: item.id)
                return true
            }
            .padding(10)
//            .background(.gray.opacity(0.2), in: .capsule)
            .padding(5)
            .padding(.trailing, 10)
        }
    }

    @ViewBuilder
    func underlyingScroller(column: KanbanColumn) -> some View {
        ScrollView(.vertical) {
            ForEach(column.items.values.sorted(), id: \.title) { item in
                KanbanItemView(rootKanbanItem: item)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .draggable(item)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func topTabBar() -> some View {
        HStack {
            Text("Daily Kanban")
                .font(.largeTitle.bold())
                .padding([.vertical], 10)
                .padding([.horizontal], 35)
                .background(.gray.opacity(0.2), in: .capsule)
                .frame(alignment: .center)
            Button {
                withAnimation {
                    /// TODO: Implement settings
                }
            } label: {
                Image(systemName: "gear")
                    .tint(.black)
            }.padding(.trailing)
        }
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
            .padding(.horizontal, 15)
        }
        
    }
    
    func addItem(_ item: KanbanItem) {
        item.id = board.globalItemIdCounter
        board.addItem(item, toColumn: board.currentlySelectedColumnId)
        board.globalItemIdCounter += 1
    }
}

#Preview {
    ContentView()
}
