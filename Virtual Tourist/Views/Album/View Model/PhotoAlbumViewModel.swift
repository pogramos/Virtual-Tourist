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

    private var entities = [PhotoEntity]()
    private (set) var photos: [PhotoEntity] {
        get {
            return self.entities
        }
        set (photos) {
            self.entities = photos
        }
    }

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<PhotoEntity> = makeFetchedResultsController()

    init(_ dataController: DataController, for location: PinEntity) {
        self.dataController = dataController
        self.location = location
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
            self.photos = photos
            
            delegate?.finishedFetching(photos: photos)
        } else {
            searchPhotos()
        }
    }

    /// Search photos from flickr by the specific coordinate of the location
    func searchPhotos() {
        let parameters: [String: AnyObject] = [
            FlickrAPI.Key.Latitute: location.latitude as AnyObject,
            FlickrAPI.Key.Longitude: location.longitude as AnyObject
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
                self.delegate?.finishedFetching(photos: [])
            }
        })
    }

    func savePhotosAndUpdateUI(photos: [Photo]) {
        for photo in photos {
            let photoEntity = PhotoEntity(context: dataController.viewContext)
            photoEntity.identifier = photo.identifier
            photoEntity.locationEntity = location
            photoEntity.url = photo.url

            self.photos.append(photoEntity)
        }

        do {
            if self.photos.count > 0 {
                try dataController.viewContext.save()
            }
            performUIUpdatesOnMain {
                self.delegate?.finishedFetching(photos: self.photos)
            }
        } catch let error {
            fatalError("\(error.localizedDescription)")
        }
    }

    func photo(at indexPath: IndexPath) -> PhotoEntity {
        return self.photos[indexPath.row]
    }

    func save() {
        do {
            try dataController.viewContext.checkAndSave()
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
        guard let photo = anObject as? PhotoEntity else {
            preconditionFailure("All changes observed in the map view controller should be for LocationEntity instances")
        }

        switch type {
        case .insert:
            break
        case .delete:
            delegate?.removed(photo: photo)
        default:
            break
        }
    }
}
