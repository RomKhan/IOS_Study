//
//  Note+CoreDataProperties.swift
//  rokhanPW4
//
//  Created by Roman on 23.10.2021.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var creationDate: Date
    @NSManaged public var descriptionText: String?
    @NSManaged public var title: String?
    @NSManaged public var relationship: Note?

}

extension Note : Identifiable {

}
