//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 25.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: Constants.photo);
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var pin: Pin?

}
