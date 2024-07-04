//
//  KanbanItemView.swift
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

#Preview {
    KanbanItemView()
}
