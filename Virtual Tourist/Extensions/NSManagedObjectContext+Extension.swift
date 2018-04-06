//
//  NSManagedObjectContext+Extension.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func checkAndSave() throws {
        do {
            if self.hasChanges {
                try self.save()
            }
        } catch let error {
            throw error
        }
    }

}
