//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var viewModel: MapViewModel!

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self

        setupGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
        if let region = viewModel.initialRegion {
            mapView.region = region
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    /// Setup the longpress gesture for the mapView
    /// to add the new pin on the selected location
    fileprivate func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        longPressGesture.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPressGesture)
    }

    @objc func longPressAction(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            viewModel.addAnnotation(on: coordinate)
        }
    }

    func add(location: LocationEntity) {
        mapView.addAnnotation(location)
    }

    func remove(location: LocationEntity) {
        mapView.removeAnnotation(location)
    }
}

extension MapViewController: MapViewModelProtocol {
    func finishedFetching(locations: [LocationEntity]) {
        for point in locations {
            add(location: point)
        }
    }

    func added(location: LocationEntity) {
        add(location: location)
    }

    func removed(location: LocationEntity) {
        remove(location: location)
    }

    func updated(location: LocationEntity) {
        remove(location: location)
        add(location: location)
    }
}
