//
//  ClientAPI.swift
//  Virtual Tourist
//
//  Created by Guilherme on 4/5/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

class ClientAPI {
    typealias SuccessBlock<T> = (_ result: T?) -> Void
    typealias FailureBlock = (_ failure: ClientError?) -> Void

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func get<T: Decodable>(request: URLRequest, for type: T.Type, success: @escaping SuccessBlock<T>, failure: @escaping FailureBlock) {
        let task = taskHandler(request: request, success: { data in
            do {
                let decoded = try JSONDecoder().decode(type, from: data)
                success(decoded)
            } catch let error {
                failure(.decodeFailure(error))
            }
        }, failure: failure)

        task.resume()
    }

    func taskHandler(request: URLRequest, success: @escaping (Data) -> Void, failure: @escaping (ClientError?) -> Void) -> URLSessionDataTaskProtocol {
        return session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                if let e = error as? URLError {
                    switch e.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        failure(.unavailableConnection(e))
                    default:
                        failure(.error(e))
                    }
                } else {
                    failure(.error(error))
                }
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 403 else {
                failure(.unauthorized(error))
                return
            }

            guard statusCode >= 200 && statusCode <= 299 else {
                failure(.networkFailure(error))
                return
            }

            if let data = data {
                success(data)
            } else {
                failure(.noResultsFound(error))
            }
        })
    }
}
