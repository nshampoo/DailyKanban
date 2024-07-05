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
        Rectangle()
            .padding()
            .frame(height: 200)
            .overlay(
                Rectangle()
                    .fill(.teal)
                    .overlay(
                        HStack(alignment: .center) {
                            Spacer()
                            UnderlyingKanbanItemView(rootKanbanItem: rootKanbanItem)
                            Button {
                                withAnimation {
                                    handleButtonClick()
                                }
                            } label: {
                                /// Can we make this a delete button? What does that look like
                                Image(systemName: "gear")
                            }.padding(.trailing)
                        }
                    )
            )
    }
    
    // This doens't mutate teh original
    private func handleButtonClick() {
        // no-op
    }
}

struct UnderlyingKanbanItemView: View {
    @State var rootKanbanItem: KanbanItem
    
    var body: some View {
        VStack {
            HStack {
                Text(rootKanbanItem.title)
                    .font(.title.bold())
                Spacer()
            }
            .padding([.bottom, .trailing, .leading])
            
            Text(rootKanbanItem.description)
                .font(.footnote)
        }
        .padding()
        .background(.gray.opacity(0.8))
    }
}

#Preview {
    KanbanItemView(rootKanbanItem: KanbanItem.random(withId: 0))
}
