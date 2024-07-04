//
//  SwiftUIView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/4/24.
//

import SwiftUI

struct KanbanItemView: View {
    var body: some View {
        Rectangle()
            .fill(.gray)
            .padding()
            .frame(height: 250)
            .overlay(
                Rectangle()
                    .fill(.mint)
                    .overlay(
                        UnderlyingKanbanItemView()
                            .padding()
                    )
            )
        }
}

struct UnderlyingKanbanItemView: View {
    @State var rootKanbanItem = KanbanItem()

    var body: some View {
        VStack {
            HStack {
                Text(rootKanbanItem.title)
                    .font(.largeTitle.bold())
                Spacer()
                Button("X") {
                    withAnimation {
                        handleButtonClick()
                    }
                }
            }
            .padding([.bottom, .trailing, .leading])
            
            Text(rootKanbanItem.description)
                .font(.footnote)
        }
        .background()
    }
    
    private func handleButtonClick() {
        rootKanbanItem.mutate()
    }
}


struct KanbanItem {
    var title: String = "Clean Dishes"
    
    /// This is only for testing
    let possibleTites: [String] = ["Clean Dishes", "Cry in a Corner", "Say hi to Girlfriend", "Read a Book"]
    
    var description: String =
    """
    We need to be able to cite a lot of information here
    1. This could be subtasks
    2. Or this could just be other things that need to be done
    """
    
    /// The time in hours beetween this item coming back
    var retention: Double = 30 * 24
    
    /// Again this is only for testing, I imagine in a perfect world when this app is done we have a separate view that would edit these, and if we choose mutation or creation of a new item
    mutating func mutate() {
        title = possibleTites.randomElement() ?? "Failed to get random?"
    }
}

#Preview {
    KanbanItemView()
}
