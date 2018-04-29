//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/28/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

struct Constants {
    enum Error: String {
        case forbiddenAccess = "Unauthorized user"
        case common = "There was an error processing your request"
        case encode = "Failed to encode object"
        case decode = "Failed to decode object"
        case notFound = "No data was returned by the request"
    }

}
