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
    var mapHandler: MapHandler!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loader.show(on: self)

        viewModel.fetchData()

        if let region = viewModel.initialArea {
            mapView.region = region.region
        }

        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    /// Setting up the class delegates and handlers
    fileprivate func setupDelegates() {
        viewModel.delegate = self
        mapHandler = MapHandler(self)
        mapView.delegate = mapHandler
    }

    /// Setup the longpress gesture for the mapView
    /// to add the new pin on the selected location
    fileprivate func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        longPressGesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(longPressGesture)
    }

    @objc func longPressAction(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            Loader.show(on: self)
            viewModel.addAnnotation(on: coordinate)
        }
    }
}

extension MapViewController: MapHandlerProtocol {
    func updateCentral(region: MKCoordinateRegion) {
        viewModel.updateInitialArea(region: region)
    }

    func pushViewController(with selectedRegion: PinEntity, span: MKCoordinateSpan) {
        let viewController = PhotoAlbumViewController.instance()
        viewController.viewModel = PhotoAlbumViewModel(viewModel.dataController, for: selectedRegion, span: span)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MapViewController: MapViewModelProtocol {
    func savedPhotos() {
        Loader.hide()
    }

    func finishedFetching(locations: [PinEntity]) {
        for point in locations {
            mapView.addAnnotation(point)
        }
        Loader.hide()
    }

    func added(location: PinEntity) {
        mapView.addAnnotation(location)
        Loader.show(on: self)
        viewModel.fetchPhotos(on: location)
    }

    func removed(location: PinEntity) {
        mapView.removeAnnotation(location)
    }

    func updated(location: PinEntity) {
        mapView.removeAnnotation(location)
        mapView.addAnnotation(location)
    }
}
