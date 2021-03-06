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

    var initialArea: Region?

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<PinEntity> = makeFetchedResultsController()

    init(_ dataController: DataController) {
        self.dataController = dataController

        let fetchRegion: NSFetchRequest<Region> = Region.fetchRequest()
        do {
            if let region = try dataController.viewContext.fetch(fetchRegion).first {
                initialArea = region
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Location handling

    /// Make an instance of a NSFetchedResultsController for its lazy var
    ///
    /// - Returns: NSFetchedResultsController<LocationEntity> for a lazy var
    fileprivate func makeFetchedResultsController() -> NSFetchedResultsController<PinEntity> {
        let fetchRequest: NSFetchRequest<PinEntity> = PinEntity.fetchRequest()
        fetchRequest.sortDescriptors = []

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }

    func updateInitialArea(region: MKCoordinateRegion) {

        if initialArea == nil {
            initialArea = Region(context: dataController.viewContext)
        }
        initialArea?.region = region

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
        let locationEntity = PinEntity(context: dataController.viewContext)

        locationEntity.latitude = Float(coordinate.latitude)
        locationEntity.longitude = Float(coordinate.longitude)

        try? dataController.viewContext.save()
    }

    // -------------------------------------------------------------------------
    // MARK: - Photo handling

    func fetchPhotos(on location: PinEntity) {
        let parameters: [String: AnyObject] = [
            FlickrAPI.Key.Longitude: location.longitude as AnyObject,
            FlickrAPI.Key.Latitute: location.latitude as AnyObject
        ]
        FlickrAPI.searchPhotos(with: parameters, success: { photo in
            FlickrAPI.save(photos: photo?.photo ?? [], for: location, on: self.dataController.viewContext, completion: {
                performUIUpdatesOnMain {
                    self.delegate?.savedPhotos()
                }
            })
        }, failure: { error in
            fatalError(error.localizedDescription)
        })
    }
}

extension MapViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let location = anObject as? PinEntity else {
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
            fatalError("No moving pins... yet")
        }
    }
}
