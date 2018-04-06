//
//  MockURLSession.swift
//  Virtual TouristTests
//
//  Created by Guilherme on 4/6/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation
@testable import Virtual_Tourist

class MockURLSession: URLSessionProtocol {
    var mockTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?

    var nextResponse: URLResponse?
    var nextData: Data? {
        didSet {
            if nextData == nil {
                nextError = NSError(domain: "error", code: 0, userInfo: nil)
            }
        }
    }
    var nextError: Error?

    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, nextResponse, nextError)
        return mockTask
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, nextResponse, nextError)
        return mockTask
    }

    class func response200() -> URLResponse {
        return HTTPURLResponse(url: URL(string: "http://localhost")!,
                               statusCode: 200,
                               httpVersion: nil,
                               headerFields: nil)!
    }
}
