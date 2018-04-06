//
//  ClientResponse.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

enum ClientError {
    case unauthorized(Error?)
    case error(Error?)
    case encodeFailure(Error?)
    case decodeFailure(Error?)
    case networkFailure(Error?)
    case noResultsFound(Error?)
    case unavailableConnection(Error?)

    var localizedDescription: String {
        switch self {
        case .unauthorized(let e): return "Unauthorized user \(e?.localizedDescription ?? "")"
        case .encodeFailure(let e): return "Failed to encode object \(e?.localizedDescription ?? "")"
        case .decodeFailure(let e): return "Failed to decode object \(e?.localizedDescription ?? "")"
        case .noResultsFound(let e): return "No data was returned by the request \(e?.localizedDescription ?? "")"
        case .error(let e), .networkFailure(let e), .unavailableConnection(let e): return "There was an error with your request \(e?.localizedDescription ?? "")"
        }
    }
}
