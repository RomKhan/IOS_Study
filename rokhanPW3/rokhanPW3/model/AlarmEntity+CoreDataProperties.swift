//
//  AlarmEntity+CoreDataProperties.swift
//  rokhanPW3
//
//  Created by Roman on 10.10.2021.
//
//

import Foundation
import CoreData


extension AlarmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmEntity> {
        return NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var minutes: Int32
    @NSManaged public var name: String?
    @NSManaged public var hours: Int32

}

extension AlarmEntity : Identifiable {

}
