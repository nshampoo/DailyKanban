//
//  ViewItemView.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/6/24.
//

import SwiftUI

struct ViewItemView: View {
    @ObservedObject var item: KanbanItem

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
            ForEach(item.todoItems) { item in
                GeometryReader {
                    let size = $0.size
                    let imageString = item.isComplete ? "checkmark.square" : "square"
                    Button {
                        item.isComplete.toggle()
                    } label: {
                        HStack {
                            Image(systemName: imageString)
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
