//
//  Result.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Result: Codable {
    let photos: Photos?
    let stat: String?
}

extension Result: Equatable {
    static func == (lhs: Result, rhs: Result) -> Bool {
        if let lPhotos = lhs.photos, let rPhotos = rhs.photos, lhs.stat == rhs.stat {
            return lPhotos == rPhotos
        }
        return false
    }
}
