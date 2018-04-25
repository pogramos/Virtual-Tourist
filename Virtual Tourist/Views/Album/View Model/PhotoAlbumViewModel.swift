//
//  PhotoAlbumViewModel.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/9/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class PhotoAlbumViewModel: NSObject {

    weak var delegate: PhotoAlbumViewModelProtocol?
    var dataController: DataController!
    let location: PinEntity!
    let span: MKCoordinateSpan!
    private (set) var region: MKCoordinateRegion!

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<PhotoEntity> = makeFetchedResultsController()

    init(_ dataController: DataController, for location: PinEntity, span: MKCoordinateSpan) {
        self.dataController = dataController
        self.location = location
        self.span = span
        region = MKCoordinateRegionMake(self.location.coordinate, self.span)
    }

    /// Create an instance of a NSFetchedResultsController for a lazy var
    ///
    /// - Returns: NSFetchedResultsController<PhotoEntity> for a lazy var
    fileprivate func makeFetchedResultsController() -> NSFetchedResultsController<PhotoEntity> {
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "locationEntity == %@", location)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "photos_\(location.latitude)_\(location.longitude)")
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

        if let photos = fetchedResultsController.fetchedObjects, photos.count > 0 {
            delegate?.finishedFetching()
        } else {
            searchPhotos()
        }
    }

    func fetchNewCollection() {
        if let photos = self.fetchedResultsController.fetchedObjects {
            for photo in photos {
                self.dataController.viewContext.delete(photo)
            }

            self.save()
        }
        searchPhotos()
    }

    /// Search photos from flickr by the specific coordinate of the location
    func searchPhotos() {
        let parameters: [String: AnyObject] = [
            FlickrAPI.Key.Longitude: location.longitude as AnyObject,
            FlickrAPI.Key.Latitute: location.latitude as AnyObject
        ]

        FlickrAPI.searchPhotos(with: parameters, success: { photos in
            if let photos = photos {
                self.savePhotosAndUpdateUI(photos: photos)
            } else {
                self.savePhotosAndUpdateUI(photos: [])
            }
        }, failure: { error in
            print(error.localizedDescription)
            performUIUpdatesOnMain {
                self.delegate?.finishedFetching()
            }
        })
    }

    /// Save photos to the Core Data model and update the UI when finished
    ///
    /// - Parameter photos: return a collection of Photos
    func savePhotosAndUpdateUI(photos: [Photo]) {
        FlickrAPI.save(photos: photos, for: location, on: dataController.viewContext) {

            performUIUpdatesOnMain {
                self.delegate?.finishedFetching()
            }
        }
    }

    func photo(at indexPath: IndexPath) -> PhotoEntity {
        return fetchedResultsController.object(at: indexPath)
    }

    func numberOfItemsInSection(section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func save(_ block: (() -> Void)? = nil) {
        do {
            try dataController.viewContext.checkAndSave()
            if let block = block {
                block()
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    func removePhoto(at indexPath: IndexPath) {
        do {
            let photo = fetchedResultsController.object(at: indexPath)
            dataController.viewContext.delete(photo)
            try dataController.viewContext.checkAndSave()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

extension PhotoAlbumViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            delegate?.removed()
        default:
            break
        }
    }
}
