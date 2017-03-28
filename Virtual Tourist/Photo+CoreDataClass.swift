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
    convenience init(photo: NSData, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Constants.photo, in: context) {
            self.init(entity: ent, insertInto: context)
            self.photo = photo
        } else {
            fatalError(Constants.photoError)
        }
    }
}
