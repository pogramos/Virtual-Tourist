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
        case .unauthorized(let error): return "\(Constants.Error.forbiddenAccess) \(String(describing: error))"
        case .encodeFailure(let error): return "\(Constants.Error.encode) \(String(describing: error))"
        case .decodeFailure(let error): return "\(Constants.Error.decode) \(String(describing: error))"
        case .noResultsFound(let error): return "\(Constants.Error.notFound) \(String(describing: error))"
        case .error(let error), .networkFailure(let error), .unavailableConnection(let error): return "\(Constants.Error.common) \(String(describing: error))"
        }
    }
}
