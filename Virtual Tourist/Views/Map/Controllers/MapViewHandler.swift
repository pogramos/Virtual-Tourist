//
//  MapViewHandler.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
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
        viewModel.initialRegion = mapView.region
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    }
}
