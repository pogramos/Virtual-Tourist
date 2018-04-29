//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Photos: Codable, Equatable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]?
}
