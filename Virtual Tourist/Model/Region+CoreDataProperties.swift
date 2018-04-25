//
//  Region+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Guilherme Ramos on 24/04/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//
//

import Foundation
import CoreData

extension Region {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Region> {
        return NSFetchRequest<Region>(entityName: String(describing: self.self))
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var deltaLatitude: Double
    @NSManaged public var deltaLongitude: Double

}
