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
        case .unauthorized(let error): return "Unauthorized user \(error?.localizedDescription ?? "")"
        case .encodeFailure(let error): return "Failed to encode object \(error?.localizedDescription ?? "")"
        case .decodeFailure(let error): return "Failed to decode object \(error?.localizedDescription ?? "")"
        case .noResultsFound(let error): return "No data was returned by the request \(error?.localizedDescription ?? "")"
        case .error(let error), .networkFailure(let error), .unavailableConnection(let error): return "There was an error with your request \(error?.localizedDescription ?? "")"
        }
    }
}
