//
//  Virtual_TouristTests.swift
//  Virtual TouristTests
//
//  Created by Guilherme on 3/26/18.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import XCTest
@testable import Virtual_Tourist

class VirtualTouristTests: XCTestCase {
    var client: ClientAPI!
    var session = MockURLSession()
    override func setUp() {
        super.setUp()

        client = ClientAPI(session: session)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testClientRequest() {
        let request = ClientRequest.buildRequest(host: ClientAPI.Constants.APIHost, path: ClientAPI.Constants.APIPath, parameters: [:])

        XCTAssertEqual(request.url?.absoluteString, "\(ClientAPI.Constants.APIScheme)://\(ClientAPI.Constants.APIHost)\(ClientAPI.Constants.APIPath)")
    }

    func testGet() {
        let expected = [PhotoModel(identifier: "1a2b3c", title: "teste", url: "https://www.google.com.br")]
        let request = URLRequest(url: URL(string: "http://www.google.com.br")!)
        session.nextResponse = MockURLSession.response200()
        session.nextData = encode(expected)
        client.get(request: request, for: [PhotoModel].self, success: { data in
            XCTAssertEqual(data!, expected)
        }, failure: { (error) in
            XCTFail(error?.localizedDescription ?? "")
        })
    }

    func encode<T: Encodable>(_ data: T) -> Data? {
        do {
            return try JSONEncoder().encode(data)
        } catch {
            return nil
        }
    }

}
