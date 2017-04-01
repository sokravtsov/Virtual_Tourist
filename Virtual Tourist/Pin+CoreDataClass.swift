//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 25.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation
import CoreData
import MapKit

/// Class for Pin object
public class Pin: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // MARK: - Initializer
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Constants.pin, in: context)!
        super.init(entity: entity, insertInto: context)
        self.latitude = latitude
        self.longitude = longitude
    }
}
