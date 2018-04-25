//
//  Region+Extensions.swift
//  Virtual Tourist
//
//  Created by Guilherme Ramos on 25/04/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
import MapKit

extension Region {
    public var region: MKCoordinateRegion {
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
