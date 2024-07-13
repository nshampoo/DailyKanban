//
//  HardcodedStaticProperties.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/6/24.
//

import Foundation
import SwiftUI

/// This file represents static properties that might eventually turn into settings, or shared types. For now i'm just placing things here without law
public struct StaticProperties {
    /// This is only for testing
    static let possibleTites: [String] = ["Clean Dishes", "Cry in a Corner", "Say hi to best girlfriend ever", "Read a Book", "Lay on the Floor", "Pick up pizza", "Give smooches", "Bring Solid State to girlfriend", "Go for a long run", "Buy chocolate milk", "Build fort", "Let girlfriend pick movie for movie night", "Shave", "Post to Strava", "Give kudos"]
    
    static let description: String =
    """
    We need to be able to cite a lot of information here
    1. This could be subtasks
    2. Or this could just be other things that need to be done
    """
    
    enum PickableColors: String, CaseIterable {
        
        case Blue
        case Green
        case Red
        case Purple
        
        func asColor() -> Color {
            switch self {
            case .Blue:
                return .blue
            case .Green:
                return .green
            case .Red:
                return .red
            case .Purple:
                return .purple
            }
        }
        
        static func randomColor() -> Color {
            (PickableColors.allCases.randomElement() ?? .Blue).asColor()
        }
    }

    static func random(withId id: Int) -> KanbanItem {
        let descriptions: [String] = [StaticProperties.description, "Hi peoples!"]
        
        let description = Int.random(in: 0 ... 10) > 10 ? descriptions.randomElement() : nil
        let item = KanbanItem(id: id,
                              title: StaticProperties.possibleTites.randomElement() ?? "Failed to get random?",
                              todoItems: [.init(isComplete: false, description: "Walk to girlfriend")],
                              description: description,
                              color: PickableColors.randomColor(),
                              retention: nil)
        
        return item
    }

    static let todoColumn = KanbanColumn(id: 0, isVisible: true, name: "ToDo", items: [:])
    static let waitingColumn = KanbanColumn(id: 1, isVisible: true, name: "Waiting", items: [:])
    static let todayColumn = KanbanColumn(id: 2, isVisible: true, name: "Today", items: [:])
    static let doneColumn = KanbanColumn(id: 3, isVisible: true, name: "Done", items: [:])
    static let retentionColumn = KanbanColumn(id: 4, isVisible: false, name: "Retention", items: [:])
    static let sampleKanbanStart: [Int:KanbanColumn] = [
        0: todoColumn,
        1: waitingColumn,
        2: todayColumn,
        3: doneColumn,
    ]

}
