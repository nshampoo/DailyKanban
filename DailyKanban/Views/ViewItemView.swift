//
//  ViewItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/6/24.
//

import SwiftUI

struct ViewItemView: View {
//    @EnvironmentObject var board: KanbanBoard
    @State var item: KanbanItem
    
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
            ForEach(item.todoItems, id: \.description) { item in
                GeometryReader {
                    let size = $0.size
                    
                    Button {
                        item.isComplete.toggle()
                    } label: {
                        HStack {
                            Image(systemName: item.isComplete ? "checkmark.square" : "square")
                                .tint(.black)
                            Text(item.description)
                                .tint(.black)
                        }
                    }
                    .frame(minWidth: size.width, alignment: .leading)
                }
                
            }
            .padding()
            Spacer()
        }
        .padding()
        .frame(alignment: .top)
    }
}

#Preview {
    ViewItemView(item: StaticProperties.random(withId: 0))
}
