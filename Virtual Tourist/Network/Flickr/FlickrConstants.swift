//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

extension FlickrAPI {

    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
    }

    // -------------------------------------------------------------------------
    // MARK: - Flickr parameter keys
    struct Key {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let Latitute = "lat"
        static let Longitude = "lon"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let PerPage = "per_page"
    }

    // -------------------------------------------------------------------------
    // MARK: - Flickr parameter values
    struct Value {
        static let APIKey = "a1d7e4288e76af327a416e6cfa249888"
        static let Format = "json"
        static let DisableCallback = "1"
        static let MediumURL = "url_m"
        static let SafeSearch = "1"
        static let galleriesGetPhotos = "flickr.galleries.getPhotos"
        static let photosSearch = "flickr.photos.search"
        static let Limit = 20
    }

    // -------------------------------------------------------------------------
    // MARK: - Response Key
    struct ResponseKey {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
}
