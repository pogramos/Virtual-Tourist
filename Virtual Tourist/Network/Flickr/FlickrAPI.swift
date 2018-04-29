//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
import CoreData

class FlickrAPI {
    typealias Closure = (() -> Void)

    /// Create base parameter structure used on all methods for the flickr api
    ///
    /// - Parameter parameters: parameters dictionary
    /// - Returns: the new parameter object with all the necessary keys
    fileprivate class func base(parameters: [String: AnyObject]) -> [String: AnyObject] {
        var parameters = parameters
        parameters[Key.APIKey] = Value.APIKey as AnyObject
        parameters[Key.Extras] = Value.MediumURL as AnyObject
        parameters[Key.SafeSearch] = Value.SafeSearch as AnyObject
        parameters[Key.NoJSONCallback] = Value.DisableCallback as AnyObject
        parameters[Key.Format] = Value.Format as AnyObject
        parameters[Key.Radius] = Value.Radius as AnyObject
        parameters[Key.RadiusUnits] = Value.RadiusUnits as AnyObject

        return parameters
    }

    /// Search for photos
    ///
    /// - Parameters:
    ///   - parameters: array of parameters that will be passed to the api
    ///   - success: success block that will return with the array of photos that were found
    ///   - failure: failure block that will be invoked if the service reach any error
    class func searchPhotos(with parameters: [String: AnyObject], success: @escaping (Photos?) -> Void, failure: @escaping (ClientError) -> Void) {
        var parameters = base(parameters: parameters)
        parameters[Key.Method] = Value.photosSearch as AnyObject
        let request = ClientRequest.buildRequest(host: Constants.APIHost, path: Constants.APIPath, parameters: parameters)
        ClientAPI().get(request: request, for: Result.self, success: { result in
            success(result?.photos)
        }, failure: { error in
            failure(error ?? .error(nil))
        })
    }

    /// Search for photos based on the latitude and longitude
    ///
    /// - Parameters:
    ///   - boundingBox: a bounding box for a latitude and longitude
    ///   - success: success block that will return with the array of photos that were found
    ///   - failure: failure block that will be invoked if the service reach any error
    class func searchPhotos(on boundingBox: String, success: @escaping ([Photo]?) -> Void, failure: @escaping (ClientError) -> Void) {
        let parameters: [String: AnyObject] = [
            Key.BoundingBox: boundingBox as AnyObject,
            Key.Method: Value.photosSearch as AnyObject
        ]

        let request = ClientRequest.buildRequest(host: Constants.APIHost, path: Constants.APIPath, parameters: base(parameters: parameters))
        ClientAPI().get(request: request, for: Result.self, success: { result in
            success(result?.photos?.photo)
        }, failure: { error in
            failure(error ?? .error(nil))
        })
    }

    /// Download images from url's
    ///
    /// - Parameters:
    ///   - url: url string of an image
    ///   - completion: completion block to execute after the proccess is finished
    class func downloadImage(from url: String, completion: @escaping (Data?, String?) -> Void) {
        let imageURL = URL(string: url)
        let request = URLRequest(url: imageURL!)
        let task = ClientAPI().taskHandler(request: request, success: { data in
            performUIUpdatesOnMain {
                completion(data, nil)
            }
        }, failure: { error in
            performUIUpdatesOnMain {
                completion(nil, error?.localizedDescription)
            }
        })
        task.resume()
    }

    /// Save photos downloaded from the service on the core data
    ///
    /// - Parameters:
    ///   - photos: Photos downloaded from the server
    ///   - location: Location of the photo objects
    ///   - context: Managed Context from the CoreDataStack
    ///   - completion: Completion block to execute after the process is finished
    class func save(photos: [Photo], for location: PinEntity, on context: NSManagedObjectContext, completion: @escaping Closure) {
        for photo in photos {
            let photoEntity = PhotoEntity(context: context)
            photoEntity.identifier = photo.identifier
            photoEntity.locationEntity = location
            photoEntity.url = photo.url
        }
        do {
            try context.checkAndSave()
            completion()
        } catch {
            fatalError(error.localizedDescription)
        }

    }
}
