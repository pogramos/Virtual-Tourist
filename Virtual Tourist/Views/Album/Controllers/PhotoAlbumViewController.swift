//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/9/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MapHandlerProtocol {
    var viewModel: PhotoAlbumViewModel!
    var mapHandler: MapHandler!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    class func instance() -> Self {
        return instance(from: "Album", identifier: String(describing: self.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loader.show(on: self)
        viewModel.fetchData()
        mapView.addAnnotation(viewModel.location)
        mapView.setRegion(viewModel.region, animated: true)
    }

    fileprivate func setupDelegates() {
        viewModel.delegate = self
        mapHandler = MapHandler(self)
        mapView.delegate = mapHandler
    }

    @IBAction func newCollection(_ sender: Any) {
        Loader.show(on: self)
        viewModel.fetchNewCollection()
    }
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotoAlbumCollectionViewCell {
            config(cell: cell, at: indexPath)

            return cell
        }
        return UICollectionViewCell()
    }

    /// Configure cell with the indexPath of the items stored on the viewModel
    ///
    /// - Parameters:
    ///   - cell: current cell of the collectionview
    ///   - indexPath: indexpath of the item
    fileprivate func config(cell: PhotoAlbumCollectionViewCell, at indexPath: IndexPath) {
        let photo = self.viewModel.photo(at: indexPath)
        if let data = photo.photo {
            cell.setupImage(data: data)
        } else {
            cell.activityIndicator.startAnimating()
            if let url = photo.url {
                FlickrAPI.downloadImage(from: url) { data in
                    if let data = data {
                        cell.setupImage(data: data)
                        photo.photo = data
                        self.viewModel.save()
                    }
                }
            }
        }
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Loader.show(on: self)
        collectionView.performBatchUpdates({
            self.viewModel.removePhoto(at: indexPath)
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
}

extension PhotoAlbumViewController: PhotoAlbumViewModelProtocol {
    func finishedFetching() {
        Loader.hide()
        collectionView.reloadData()
    }

    func updated(photos: [PhotoEntity]) {

    }

    func removed() {
        Loader.hide()
    }
}
