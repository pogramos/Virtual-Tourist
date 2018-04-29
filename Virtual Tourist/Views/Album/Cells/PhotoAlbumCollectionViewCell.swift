//
//  PhotoAlbumCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Guilherme Ramos on 18/04/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func setupImage(data: Data) {
        self.imageView.image = UIImage(data: data)
        self.imageView.alpha = 1
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
    }

    func setDefaultImage() {
        self.imageView.image = #imageLiteral(resourceName: "Default-Image")
        self.imageView.alpha = 0.3
        self.activityIndicator.startAnimating()
    }
}
