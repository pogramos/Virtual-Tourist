//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Photo: Codable, Equatable {
    let identifier: String?
    let title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case url = "url_m"
    }
}
