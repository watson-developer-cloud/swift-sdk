/**
 * Copyright IBM Corporation 2016-2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import RestKit
@testable import VisualRecognitionV3

class VisualRecognitionUnitTests: XCTestCase {

    private var visualRecognition: VisualRecognition!

    let exampleURL = URL(string: "http://example.com")!
    private let timeout = 1.0

    override func setUp() {
        super.setUp()
        let accessToken = "my_access_token"
        visualRecognition = VisualRecognition(version: currentDate, accessToken: accessToken)
        // Create mock session
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        visualRecognition.session = mockSession
    }

    func testHeaders() throws {
        // Configure mock
        MockURLProtocol.requestHandler = { request in
            // Verify custom header is present
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertTrue(request.allHTTPHeaderFields?.keys.contains("x-foo") ?? false)
            XCTAssertEqual("bar", request.allHTTPHeaderFields?["x-foo"])

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "Classify an image with explicit headers.")
        let imageURL = "an-image-url"
        visualRecognition.classify(url: imageURL, headers: ["x-foo": "bar"]) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: errorResponseDecoder

    func testErrorResponseDecoder403() {
        let testJSON: [String: JSON] = [
            "status": JSON.string("403"),
            "statusInfo": JSON.string("forbidden"),
        ]
        let testData = try! JSONEncoder().encode(testJSON)
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 403, httpVersion: nil, headerFields: nil)!

        let error = visualRecognition.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, metadata) = error {
            XCTAssertEqual(statusCode, 403)
            XCTAssertNotNil(message)
            XCTAssertNotNil(metadata)
            XCTAssertNotNil(metadata!["status"])
            XCTAssertNotNil(metadata!["statusInfo"])
        }
    }

    func testErrorResponseDecoder404() {
        let testJSON: [String: JSON] = [
            "error": JSON.object([
                "description": JSON.string("not found"),
                "error_id": JSON.string("42"),
            ]),
        ]
        let testData = try! JSONEncoder().encode(testJSON)
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 404, httpVersion: nil, headerFields: nil)!

        let error = visualRecognition.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, metadata) = error {
            XCTAssertEqual(statusCode, 404)
            XCTAssertNotNil(message)
            XCTAssertNotNil(metadata?["description"])
            XCTAssertNotNil(metadata?["errorID"])
        }
    }

    func testErrorResponseDecoder413() {
        let testJSON: [String: JSON] = ["Error": JSON.string("failed")]
        let testData = try! JSONEncoder().encode(testJSON)
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 413, httpVersion: nil, headerFields: nil)!

        let error = visualRecognition.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, _) = error {
            XCTAssertEqual(statusCode, 413)
            XCTAssertNotNil(message)
        }
    }

    func testErrorResponseDecoderDefault() {
        let testJSON: [String: JSON] = ["error": JSON.string("failed")]
        let testData = try! JSONEncoder().encode(testJSON)
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 500, httpVersion: nil, headerFields: nil)!

        let error = visualRecognition.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, _) = error {
            XCTAssertEqual(statusCode, 500)
            XCTAssertNotNil(message)
        }
    }

    func testErrorResponseDecoderBadJSON() {
        let testData = Data()
        let testResponse = HTTPURLResponse(url: exampleURL, statusCode: 500, httpVersion: nil, headerFields: nil)!

        let error = visualRecognition.errorResponseDecoder(data: testData, response: testResponse)
        if case let .http(statusCode, message, metadata) = error {
            XCTAssertEqual(statusCode, 500)
            XCTAssertNil(message)
            XCTAssertNil(metadata)
        }
    }

    // MARK: Classifiers

    func testClassify() {
        let owners = ["Anthony", "Mike"]
        let classifierIDs = ["1", "2"]

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual("classify", request.url?.pathComponents.last)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = parseMultiPartFormBody(request: request)
            XCTAssertEqual(5, bodyFieldsCount)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "classify")
        visualRecognition.classify(imagesFile: obama, url: "http://example.com", threshold: 1.0, owners: owners, classifierIDs: classifierIDs, acceptLanguage: "en") {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateClassifier() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual("classifiers", request.url?.pathComponents.last)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = parseMultiPartFormBody(request: request)
            XCTAssertEqual(4, bodyFieldsCount)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "createClassifier")
        visualRecognition.createClassifier(name: "test-classifier", positiveExamples: [carExamples, trucksExamples], negativeExamples: baseball) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListClassifiers() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual("classifiers", request.url?.pathComponents.last)
            XCTAssertTrue(request.url?.query?.contains("verbose=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "listClassifiers")
        visualRecognition.listClassifiers(owners: ["Anthony", "Mike"], verbose: true) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testGetClassifier() {
        let classifierID = "1234567890"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            let endOfURL = request.url!.pathComponents.suffix(2)
            XCTAssertEqual("classifiers", endOfURL.first)
            XCTAssertEqual(classifierID, endOfURL.last)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getClassifier")
        visualRecognition.getClassifier(classifierID: classifierID) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testUpdateClassifier() {
        let classifierID = "1234567890"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let endOfURL = request.url!.pathComponents.suffix(2)
            XCTAssertEqual("classifiers", endOfURL.first)
            XCTAssertEqual(classifierID, endOfURL.last)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = parseMultiPartFormBody(request: request)
            XCTAssertEqual(3, bodyFieldsCount)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "updateClassifier")
        visualRecognition.updateClassifier(classifierID: classifierID, positiveExamples: [carExamples, trucksExamples], negativeExamples: baseball) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDeleteClassifier() {
        let classifierID = "1234567890"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            let endOfURL = request.url!.pathComponents.suffix(2)
            XCTAssertEqual("classifiers", endOfURL.first)
            XCTAssertEqual(classifierID, endOfURL.last)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (HTTPURLResponse(), Data())
        }
        let expectation = self.expectation(description: "deleteClassifier.")
        visualRecognition.deleteClassifier(classifierID: classifierID) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: Faces

    func testDetectFaces() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual("detect_faces", request.url?.pathComponents.last)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = parseMultiPartFormBody(request: request)
            XCTAssertEqual(2, bodyFieldsCount)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "detectFaces")
        visualRecognition.detectFaces(imagesFile: faces, url: "http://example.com") {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: Core ML model

    func testGetCoreMlModel() {
        let classifierID = "1234567890"

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            let endOfURL = request.url!.pathComponents.suffix(3)
            XCTAssertEqual("classifiers", endOfURL[endOfURL.startIndex])
            XCTAssertEqual(classifierID, endOfURL[endOfURL.startIndex + 1])
            XCTAssertEqual("core_ml_model", endOfURL[endOfURL.startIndex + 2])
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (HTTPURLResponse(), Data())
        }

        let expectation = self.expectation(description: "getCoreMlModel")
        visualRecognition.getCoreMlModel(classifierID: classifierID) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: User data

    func testDeleteUserData() {
        let customerID = "1234567890"

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertEqual("user_data", request.url?.pathComponents.last)
            XCTAssertTrue(request.url?.query?.contains("version=\(currentDate)") ?? false)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (HTTPURLResponse(), Data())
        }
        let expectation = self.expectation(description: "deleteClassifier.")
        visualRecognition.deleteUserData(customerID: customerID) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
}
