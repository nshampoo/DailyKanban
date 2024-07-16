//
//  PersistableTodoItem+CoreDataClass.swift
//  DailyKanban
//
//  Created by Nicholas Shampoe on 7/14/24.
//
//

import Foundation
import CoreData

@objc(PersistableTodoItem)
public class PersistableTodoItem: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case isComplete, desc, order
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init(context: DataController.shared.persistentContainer.viewContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        desc = try container.decode(String.self, forKey: .desc)
        order = try container.decode(Int16.self, forKey: .order)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(desc, forKey: .desc)
        try container.encode(order, forKey: .order)
        
    }
}
