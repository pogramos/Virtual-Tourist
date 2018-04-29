//
//  ClientRequest.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

class ClientRequest {

    class fileprivate func composeURL(host: String, path: String, parameters: [String: AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = FlickrAPI.Constants.APIScheme
        components.host = host
        components.path = path

        if parameters.count > 0 {
            components.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                components.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }

        return components.url!
    }

    class func buildRequest(host: String, path: String, parameters: [String: AnyObject]) -> URLRequest {
        return buildMutableRequest(host: host, path: path, parameters: parameters) as URLRequest
    }

    class func buildMutableRequest(host: String, path: String, parameters: [String: AnyObject]) -> NSMutableURLRequest {
        return NSMutableURLRequest(url: composeURL(host: host, path: path, parameters: parameters))
    }
}
