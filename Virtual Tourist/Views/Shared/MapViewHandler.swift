//
//  MapViewHandler.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import MapKit

@objc protocol MapHandlerProtocol: class {
    @objc optional func updateCentral(region: MKCoordinateRegion)
    @objc optional func presentViewController(with selectedRegion: LocationEntity)
}

class MapHandler: NSObject, MKMapViewDelegate {
    weak var delegate: MapHandlerProtocol?

    init(_ delegate: MapHandlerProtocol) {
        self.delegate = delegate
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinIdentifier = "pin"

        /// Check if a annotation view on this map for the identifier
        /// if the pin doesn't exist, create a new PinAnnotationView
        guard let pin = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)
            as? MKPinAnnotationView else {

                let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
                pin.pinTintColor = .red

                return pin
        }
        /// otherwise, just add an annotation
        pin.annotation = annotation

        return pin
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delegate?.updateCentral?(region: mapView.region)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationEntity {
            delegate?.presentViewController?(with: annotation)
        }
    }
}
