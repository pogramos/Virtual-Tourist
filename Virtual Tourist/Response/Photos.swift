//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let page: Int?
    let pages: Int?
    let perPage: Int?
    let total: String?
    let photo: [Photo]?
}

extension Photos: Equatable {
    static func == (lhs: Photos, rhs: Photos) -> Bool {
        var equal = lhs.page == rhs.page && lhs.pages == rhs.pages &&
                lhs.perPage == rhs.perPage && lhs.total == rhs.total
        if let lPhoto = lhs.photo, let rPhoto = rhs.photo {
            equal = lPhoto == rPhoto
        } else {
            equal = false
        }
        return equal
    }

}
