//
//  MapViewModel.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class MapViewModel: NSObject {

    private let latitudeKey = "vtLatitude"
    private let longitudeKey = "vtLongitude"
    private let latDeltaKey = "vtLatitudeDelta"
    private let lonDeltaKey = "vtLongitudeDelta"
    private let regionKey = "vtRegion"

    weak var delegate: MapViewModelProtocol?
    var dataController: DataController!

    var initialRegion: MKCoordinateRegion? {
        get {
            if let region = UserDefaults.standard.dictionary(forKey: regionKey) {
                if let latitudeDelta = region[latDeltaKey] as? Double, let longitudeDelta = region[lonDeltaKey] as? Double {
                    let span = MKCoordinateSpanMake(CLLocationDegrees(latitudeDelta), CLLocationDegrees(longitudeDelta))
                    if let latitude = region[latitudeKey] as? Double, let longitude = region[longitudeKey] as? Double {
                        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
                        return MKCoordinateRegionMake(coordinate, span)
                    }
                }
            }
            return nil
        }
        set {
            if let region = newValue {
                let regionDictionary: [String: Any] = [
                    latitudeKey: region.center.latitude,
                    longitudeKey: region.center.longitude,
                    latDeltaKey: region.span.latitudeDelta,
                    lonDeltaKey: region.span.longitudeDelta
                ]
                UserDefaults.standard.set(regionDictionary, forKey: regionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: regionKey)
            }
            UserDefaults.standard.synchronize()
        }
    }

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<LocationEntity> = makeFetchedResultsController()

    init(_ dataController: DataController) {
        self.dataController = dataController
    }

    /// Make an instance of a NSFetchedResultsController for its lazy var
    ///
    /// - Returns: NSFetchedResultsController<LocationEntity> for a lazy var
    fileprivate func makeFetchedResultsController() -> NSFetchedResultsController<LocationEntity> {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.sortDescriptors = []

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "locations")
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }

    /// Fetch information from the core data
    func fetchData() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            fatalError("Could not fetch locations on the database: \(error.localizedDescription)")
        }

        if let locations = fetchedResultsController.fetchedObjects {
            delegate?.finishedFetching(locations: locations)
        } else {
            delegate?.finishedFetching(locations: [])
        }
    }

    /// Save the annotation (or location entity) that was set on the mapView
    ///
    /// - Parameter coordinate: CLLocationCoordinate2D object from the annotation
    func addAnnotation(on coordinate: CLLocationCoordinate2D) {
        let locationEntity = LocationEntity(context: dataController.viewContext)

        locationEntity.latitude = Float(coordinate.latitude)
        locationEntity.longitude = Float(coordinate.longitude)

        try? dataController.viewContext.save()
    }
}

extension MapViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let location = anObject as? LocationEntity else {
            preconditionFailure("All changes observed in the map view controller should be for LocationEntity instances")
        }

        switch type {
        case .insert:
            delegate?.added(location: location)
        case .delete:
            delegate?.removed(location: location)
        case .update:
            delegate?.updated(location: location)
        case .move:
            fatalError("How did we move a Point? We have a stable sort.")
        }
    }
}
