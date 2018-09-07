//
//  VisualRecognitionUnitTests.swift
//  VisualRecognitionV3Tests
//
//  Created by Mike Kistler on 6/16/18.
//  Copyright © 2018 Glenn R. Fisher. All rights reserved.
//

import XCTest
@testable
import VisualRecognitionV3

class VisualRecognitionUnitTests: XCTestCase {

    private var visualRecognition: VisualRecognition!

    override func setUp() {
        super.setUp()
        let version = "2018-03-19"
        let accessToken = "my_access_token"
        visualRecognition = VisualRecognition(version: version, accessToken: accessToken)
        // Create mock session
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        // Install mock session
        visualRecognition.session = mockSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHeaders() throws {
        // Configure mock
        let mockResult = ["custom_classes": 0, "images_processed": 0]
        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertTrue(request.allHTTPHeaderFields?.keys.contains("x-foo") ?? false)
            XCTAssertEqual("bar", request.allHTTPHeaderFields?["x-foo"])
            return (HTTPURLResponse(), try JSONEncoder().encode(mockResult))
        }

        let expectation = self.expectation(description: "Classify an image with explicit headers.")
        let imageURL = "an-image-url"
        visualRecognition.classify(url: imageURL, headers: ["x-foo": "bar"]) {(error, _) in
            if error != nil {
                XCTFail("error return")
            } else {
              }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }

}
