//
//  AlbumViewController.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/9/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: UIViewController, MapHandlerProtocol {
    var viewModel: AlbumViewModel!
    var mapHandler: MapHandler!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    class func instance() -> Self {
        return instance(from: "Album", identifier: String(describing: self.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        mapHandler = MapHandler(self)
        mapView.delegate = mapHandler
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.addAnnotation(viewModel.location)
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }

}

extension AlbumViewController: AlbumViewModelProtocol {
    func finishedFetching(photos: [PhotoEntity]) {
        collectionView.reloadData()
    }

    func updated(photos: [PhotoEntity]) {

    }

    func removed(photo: PhotoEntity) {

    }
}
