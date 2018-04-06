//
//  LocationEntity+Extensions.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension LocationEntity: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let latitudeDegrees = CLLocationDegrees(latitude)
        let longitudeDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latitudeDegrees, longitude: longitudeDegrees)
    }

    class func keyPathsForValuesAffectingCoordinate() -> Set<String> {
        return Set([#keyPath(LocationEntity.latitude), #keyPath(LocationEntity.longitude)])
    }
}
