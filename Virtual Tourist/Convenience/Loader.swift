//
//  Loader.swift
//  Virtual Tourist
//
//  Created by Guilherme Ramos on 17/04/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

class Loader: NSObject {
    static var blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    static var indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    /// Setup loading activity properties
    ///
    /// - Parameter frame: Parent view frame
    fileprivate static func setupLoading(with frame: CGRect) {
        blurredView.frame = frame

        indicator.center = CGPoint(x: frame.midX, y: frame.midY)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }

    class func show(on viewController: UIViewController) {
        performUIUpdatesOnMain {
            setupLoading(with: viewController.view.bounds)

            viewController.view.addSubview(blurredView)
            viewController.view.addSubview(indicator)
        }
    }

    class func hide() {
        performUIUpdatesOnMain {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            blurredView.removeFromSuperview()
        }
    }
}
