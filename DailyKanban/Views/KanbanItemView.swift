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
                        /// Can we make this a delete button? What does that look like
                        Image(systemName: "gear")
                            .tint(.black)
                    }.padding(.trailing)
                }
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
//            .padding([.bottom, .trailing, .leading])
            
            if let description = rootKanbanItem.description {
                Text(description)
                    .font(.footnote)
            }
        }
        .padding()
//        .background(.gray.opacity(0.2))
    }
}

#Preview {
    KanbanItemView(rootKanbanItem: KanbanItem.random(withId: 0))
}
