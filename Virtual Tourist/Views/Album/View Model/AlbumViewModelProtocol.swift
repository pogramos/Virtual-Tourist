//
//  AlbumViewModelProtocol.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/9/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

protocol AlbumViewModelProtocol: class {
    /// Tells the delegate that the context has finished fetching the stored locations
    ///
    /// - Parameter locations: Collection of LocationEntity
    func finishedFetching(photos: [PhotoEntity])

    /// Tells the delegate that the context finished updating the photo album
    ///
    /// - Parameter location: PhotoEntity dictionary object
    func updated(photos: [PhotoEntity])
}
