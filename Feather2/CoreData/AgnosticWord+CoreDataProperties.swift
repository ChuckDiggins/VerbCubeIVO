//
//  AgnosticWord+CoreDataProperties.swift
//  VerbCubeIVO
//
//  Created by Charles Diggins on 3/20/22.
//
//

import Foundation
import CoreData


extension AgnosticWord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgnosticWord> {
        return NSFetchRequest<AgnosticWord>(entityName: "AgnosticWord")
    }

    @NSManaged public var spanish: String?
    @NSManaged public var french: String?
    @NSManaged public var english: String?
    @NSManaged public var wordType: Int16

}

extension AgnosticWord : Identifiable {

}
