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
    weak var delegate: MapViewModelProtocol?

    var fetchedResultsController: NSFetchedResultsController<LocationEntity>!
    var dataController: DataController!

    init(_ dataController: DataController) {
        self.dataController = dataController
    }

    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        fetchRequest.sortDescriptors = []

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "locations")
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetch operation could not be completed: \(error.localizedDescription)")
        }
    }

    func clearResultsController() {
        fetchedResultsController = nil
    }

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
            delegate?.removed(location: location)
            delegate?.added(location: location)
        case .move:
            fatalError("How did we move a Point? We have a stable sort.")
        }
    }
}
