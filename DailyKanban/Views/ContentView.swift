//
//  ContentView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var board: KanbanBoard
    @State var selectedTab: Int = 2 {
        didSet {
            board.currentlySelectedColumnId = selectedTab
        }
    }
    @State var trashCanSelected: Bool = false
    @State var isCreatingItem: Bool = false
    @State var isViewingItem: Bool = false
    @State var currentlyViewingItem: KanbanItem = StaticProperties.random(withId: 0) {
        didSet {
            /// Changing this value triggers the isViewingItem to go true, thus truggering teh UI to popup
            isViewingItem.toggle()
        }
    }
    @Environment(\.colorScheme) private var scheme
    
    /// "Main" function, this handles our primary app view
    var body: some View {
        VStack(spacing: 0) {
            topTabBar()
            primaryScroller()
            customTabBar()
        }
        /// Create Item View popup
        .sheet(isPresented: Binding(projectedValue: $isCreatingItem), content: {
            CreateItemNavigationView(escapingKanbanItem: addItem)
                .presentationDetents([.fraction(0.8)])
                .presentationBackground(.thinMaterial)
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(25)
        })
        /// View Item View popup
        .sheet(isPresented: Binding(projectedValue: $isViewingItem), content: { [currentlyViewingItem] in
            ViewItemView(item: currentlyViewingItem)
                .presentationDetents([.medium, .fraction(0.9)])
                .presentationBackground(.linearGradient(currentlyViewingItem.color.gradient, startPoint: .top, endPoint: .bottom))
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(25)
        })
        /// Handle Dragging of items throughout the whole screen
        .dropDestination(for: KanbanItem.self) { _, _ in
            return false
        } isTargeted: { trashCanSelected = $0 }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.gradient.opacity(0.4))
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
        .overlay(alignment: .bottomTrailing) {
            Button {
                isCreatingItem.toggle()
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
            .padding(15)
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
                    .onTapGesture {
                        self.currentlyViewingItem = item
                    }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func topTabBar() -> some View {
        HStack {
            Image(.dino)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .frame(maxWidth: 50, alignment: .topLeading)
                .padding(.leading)
            Text("Daily Kanban")
                .font(.largeTitle.bold())
                .padding([.vertical], 10)
                .padding([.horizontal])
                .frame(alignment: .center)
                .background(.gray.opacity(0.2), in: .capsule)
//            Button {
//                withAnimation {
//                    /// TODO: Implement settings
//                }
//            } label: {
//                Image(systemName: "gear")
//                    .tint(.black)
//            }
//            .padding(.trailing)
//            .frame(alignment: .topTrailing)
        }
    }
    
    @ViewBuilder
    func customTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(board.listedColumns(), id: \.name) { column in
                HStack(spacing: 10) {
                    Text(column.name)
                        .font(.callout.bold())
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
        }
        /// Background to show which one is selected
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
    
    /// Injected function that handles created items from the CreateItemView
    func addItem(_ item: KanbanItem) {
        item.id = board.globalItemIdCounter
        board.addItem(item, toColumn: 0)
        selectedTab = 0
        board.globalItemIdCounter += 1
    }
}

#Preview {
    ContentView()
}
