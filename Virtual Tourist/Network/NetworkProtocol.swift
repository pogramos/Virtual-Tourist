//
//  NetworkProtocol.swift
//  Virtual Tourist
//
//  Created by Guilherme on 3/28/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
//
// The Protocols here used to create my testings of my networking layer were taken from the reference
// indicated below
// Reference
// http://masilotti.com/testing-nsurlsession-input/
//

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let task = dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
        return task as URLSessionDataTaskProtocol
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let task = dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
        return task as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
