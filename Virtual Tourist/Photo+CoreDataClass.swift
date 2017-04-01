//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 25.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation
import CoreData

public class Photo: NSManagedObject {
    
    // MARK: - Initializer
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Constants.photo, in: context)!
        super.init(entity: entity, insertInto: context)
        self.id = dictionary[Constants.id] as? String
        self.stringURL = dictionary[Constants.urlM] as? String
    }    
}
