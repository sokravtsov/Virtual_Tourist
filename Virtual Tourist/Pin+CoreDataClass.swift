//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 25.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation
import CoreData

public class Pin: NSManagedObject {
    
    // MARK: - Initializer
    convenience init(createdAt: NSDate, latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Constants.pin, in: context) {
            self.init(entity: ent, insertInto: context)
            self.createdAt = createdAt
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError(Constants.pinError)
        }
    }
}
