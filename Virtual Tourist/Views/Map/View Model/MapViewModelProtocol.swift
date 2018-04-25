//
//  MapViewModelProtocol.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

protocol MapViewModelProtocol: class {

    /// Tells the delegate that the context has finished fetching the stored locations
    ///
    /// - Parameter locations: Collection of LocationEntity
    func finishedFetching(locations: [PinEntity])

    /// Tells the delegate that the context finished adding a location
    ///
    /// - Parameter point: LocationEntity object
    func added(location: PinEntity)

    /// Tells the delegate that the context finished removing a location
    ///
    /// - Parameter point: LocationEntity object
    func removed(location: PinEntity)

    /// Tells the delegate that the context finished updating a location
    ///
    /// - Parameter location: LocationEntity object
    func updated(location: PinEntity)

    /// Tells the delegate that the context finished saving the photos
    /// and hide the loader
    func savedPhotos()
}
