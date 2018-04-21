//
//  PhotoAlbumViewModelProtocol.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/9/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

@objc protocol PhotoAlbumViewModelProtocol: class {
    /// Tells the delegate that the context has finished fetching the photos
    func finishedFetching()

    /// Tells the delegate that the context finished updating the photo album
    ///
    /// - Parameter location: PhotoEntity dictionary object
    func updated(photos: [PhotoEntity])

    /// Tells the delegate that the context finished deleting the photo
    func removed()
}
