//
//  UIViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/10/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Generic instance method for the viewController
    ///
    /// - Parameters:
    ///   - storyboardName: Desired viewController's storyboard name
    ///   - identifier: ViewController's identifier
    /// - Returns: The viewController with the specified identifier
    class func instance(from storyboardName: String, identifier: String) -> Self {
        return genericStoryboardInstance(with: storyboardName, identifier: identifier)!
    }

    /// Get a generic viewController (type defined on execution) with an identifier
    /// from a named storyboard
    ///
    /// - Parameters:
    ///   - name: Name of the storyboard
    ///   - identifier: ViewController's identifier
    /// - Returns: Generic viewController (independent of the type)
    private class func genericStoryboardInstance<T>(with name: String, identifier: String) -> T? {
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: identifier
        )
        return controller as? T
    }
}
