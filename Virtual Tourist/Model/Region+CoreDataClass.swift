//
//  Region+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Guilherme Ramos on 24/04/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(Region)
public class Region: NSManagedObject {

    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(context: NSManagedObjectContext, region: MKCoordinateRegion) {
        let entity = NSEntityDescription.entity(forEntityName: String(describing: Region.self), in: context)
        super.init(entity: entity!, insertInto: context)
        self.region = region
    }

    var region: MKCoordinateRegion {
        get {
            return MKCoordinateRegionMake(
                CLLocationCoordinate2DMake(latitude, longitude),
                MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
            )
        }
        set (newRegion) {
            longitude = newRegion.center.longitude
            latitude = newRegion.center.latitude
            deltaLongitude = newRegion.span.longitudeDelta
            deltaLatitude = newRegion.span.latitudeDelta
        }
    }
}
