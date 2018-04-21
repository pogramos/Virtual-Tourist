//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

class FlickrAPI {

    /// Search for photos based on the latitude and longitude
    ///
    /// - Parameters:
    ///   - parameters: array of parameters that will be passed to the api
    ///   - success: success block that will return with the array of photos that were found
    ///   - failure: failure block that will be invoked if the service reach any error
    class func searchPhotos(with parameters: [String: AnyObject], success: @escaping ([Photo]?) -> Void, failure: @escaping (ClientError) -> Void) {
        var parameters = parameters
        parameters[Key.APIKey] = Value.APIKey as AnyObject
        parameters[Key.Method] = Value.photosSearch as AnyObject
        parameters[Key.Extras] = Value.MediumURL as AnyObject
        parameters[Key.SafeSearch] = Value.SafeSearch as AnyObject
        parameters[Key.NoJSONCallback] = Value.DisableCallback as AnyObject
        parameters[Key.Format] = Value.Format as AnyObject
        parameters[Key.PerPage] = Value.Limit as AnyObject

        let request = ClientRequest.buildRequest(host: Constants.APIHost, path: Constants.APIPath, parameters: parameters)
        ClientAPI().get(request: request, for: Result.self, success: { result in
            success(result?.photos?.photo)
        }, failure: { error in
            failure(error ?? .error(nil))
        })
    }

    class func downloadImage(from url: String, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: url) {
                do {
                    let data = try Data(contentsOf: imageURL)
                    performUIUpdatesOnMain {
                        completion(data)
                    }
                } catch {
                    performUIUpdatesOnMain {
                        completion(nil)
                    }
                }
            } else {
                performUIUpdatesOnMain {
                    completion(nil)
                }
            }
        }
    }
}
