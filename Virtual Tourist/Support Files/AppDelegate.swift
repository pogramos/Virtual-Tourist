//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Guilherme on 3/26/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: "Virtual_Tourist")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        dataController.load()
        if let mapViewController = window?.rootViewController as? MapViewController {
            mapViewController.viewModel = MapViewModel(dataController)
        }

        return true
    }

}
