//
//  UIViewController+UI.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentWarningAlert(with message: String?) {
        let alert = UIAlertController(title: "Warning", message: "There was an error processing your request:\n\(message ?? "")", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}
