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
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
import CoreML
#endif
@testable import VisualRecognitionV3

class VisualRecognitionUnitTests: XCTestCase {

    private var visualRecognition: VisualRecognition!
    private let timeout = 1.0

    // MARK: Test Configuration

    override func setUp() {
        super.setUp()

        visualRecognition = VisualRecognition(version: versionDate, accessToken: accessToken)
        createMockSession(for: visualRecognition)
    }

    func createMockSession(for visualRecognition: VisualRecognition) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        visualRecognition.session = mockSession
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
            XCTAssertNotNil(metadata?["response"] as? [String: Any])
            let response = metadata?["response"] as? [String: Any]
            XCTAssertNotNil(response?["status"])
            XCTAssertNotNil(response?["statusInfo"])
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
            XCTAssertNotNil(metadata?["response"] as? [String: JSON])
            let response = metadata?["response"] as? [String: JSON]
            XCTAssertNotNil(response?["error"])
            if case let .some(.object(responseError)) = response?["error"] {
                XCTAssertNotNil(responseError["description"])
                XCTAssertNotNil(responseError["error_id"])
            } else {
                XCTFail("error not present in response")
            }
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
            XCTAssertNotNil(message)
            XCTAssertEqual("internal server error", message)
            XCTAssertNotNil(metadata)
            XCTAssertNotNil(metadata?["response"])
        }
    }

    // MARK: Classifiers

    func testClassify() {
        let owners = ["Anthony", "Mike"]
        let classifierIDs = ["1", "2"]

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.lastPathComponent, "classify")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
            XCTAssertEqual(bodyFieldsCount, 5)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "classify")
        visualRecognition.classify(imagesFile: obama, imagesFileContentType: "png", url: "http://example.com", threshold: 1.0, owners: owners, classifierIDs: classifierIDs) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testHeaders() throws {
        MockURLProtocol.requestHandler = { request in
            // Verify custom header is present
            XCTAssertNotNil(request.allHTTPHeaderFields)
            XCTAssertTrue(request.allHTTPHeaderFields?.keys.contains("x-foo") ?? false)
            XCTAssertEqual(request.allHTTPHeaderFields?["x-foo"], "bar")

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "Classify an image with explicit headers.")
        let imageURL = "an-image-url"
        visualRecognition.classify(url: imageURL, headers: ["x-foo": "bar"]) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testCreateClassifier() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.lastPathComponent, "classifiers")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
            XCTAssertEqual(bodyFieldsCount, 4)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "createClassifier")
        visualRecognition.createClassifier(name: "test-classifier", positiveExamples: ["car": car, "trucks": trucks], negativeExamples: baseball) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testListClassifiers() {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url?.lastPathComponent, "classifiers")
            XCTAssertTrue(request.url?.query?.contains("verbose=true") ?? false)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "listClassifiers")
        visualRecognition.listClassifiers(verbose: true) {
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
            XCTAssertEqual(endOfURL.first, "classifiers")
            XCTAssertEqual(endOfURL.last, classifierID)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (dummyResponse, Data())
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
            XCTAssertEqual(endOfURL.first, "classifiers")
            XCTAssertEqual(endOfURL.last, classifierID)
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
            XCTAssertEqual(bodyFieldsCount, 3)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "updateClassifier")
        visualRecognition.updateClassifier(classifierID: classifierID, positiveExamples: ["car": car, "trucks": trucks], negativeExamples: baseball) {
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
            XCTAssertEqual(endOfURL.first, "classifiers")
            XCTAssertEqual(endOfURL.last, classifierID)
            XCTAssertNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (dummyResponse, Data())
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
            XCTAssertEqual(request.url?.lastPathComponent, "detect_faces")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)

            let headers = request.allHTTPHeaderFields
            XCTAssertNotNil(headers)
            if let headers = headers {
                XCTAssertNotNil(headers["Accept-Language"])
                if let acceptLanguage = headers["Accept-Language"] {
                    XCTAssertEqual(acceptLanguage, "en")
                }
            }

            let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
            XCTAssertEqual(bodyFieldsCount, 2)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "detectFaces")
        visualRecognition.detectFaces(imagesFile: faces, url: "http://example.com", acceptLanguage: "en") {
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
            XCTAssertEqual(endOfURL[endOfURL.startIndex], "classifiers")
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], classifierID)
            XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "core_ml_model")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "getCoreMlModel")
        visualRecognition.getCoreMLModel(classifierID: classifierID) {
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
            XCTAssertEqual(request.url?.lastPathComponent, "user_data")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            return (dummyResponse, Data())
        }
        let expectation = self.expectation(description: "deleteUserData")
        visualRecognition.deleteUserData(customerID: customerID) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

#if os(iOS) || os(tvOS) || os(watchOS)

    // MARK: - VisualRecognition+CoreML

    func testGetAndDeleteLocalModel() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let classifierID = "watson_tools"

            do {
                // Save a CoreML file to the Application Support directory on the simulator for the duration of this test
                saveCoreMLModelToSimulator(name: classifierID, modelURL: watson_tools.urlOfModelInThisBundle)
                defer {
                    deleteLocalCoreMLModels(classifierIDs: [classifierID])
                }

                // Then check if getLocalModel() can properly retrieve that model
                let localModel = try visualRecognition.getLocalModel(classifierID: classifierID)
                XCTAssertEqual(localModel.modelDescription.metadata[MLModelMetadataKey.author] as? String, "IBM")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testUpdateLocalModelWithOutdatedModel() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let classifierID = "watson_sample"

            // Pretend that the VR service has a newly-retrained version of the CoreML model
            class MockVisualRecognition: VisualRecognition {

                let expectation: XCTestExpectation

                init(version: String, accessToken: String, expectation: XCTestExpectation) {
                    self.expectation = expectation
                    super.init(version: version, accessToken: accessToken)
                }

                override func getClassifier(
                    classifierID: String,
                    headers: [String: String]?,
                    completionHandler: @escaping (RestResponse<Classifier>?, WatsonError?) -> Void) {

                    expectation.fulfill()

                    var response: RestResponse<Classifier> = RestResponse(statusCode: 200)
                    response.result = Classifier(
                        classifierID: classifierID,
                        name: classifierID,
                        owner: nil,
                        status: "ready",
                        coreMLEnabled: true,
                        explanation: nil,
                        created: nil,
                        classes: nil,
                        retrained: Date(),
                        updated: nil)
                    completionHandler(response, nil)
                }
            }

            // We expect the newer CoreML model to be downloaded
            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.httpMethod, "GET")
                let endOfURL = request.url!.pathComponents.suffix(3)
                XCTAssertEqual(endOfURL[endOfURL.startIndex], "classifiers")
                XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], classifierID)
                XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "core_ml_model")
                XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
                XCTAssertNil(request.httpBodyStream)
                XCTAssertNotNil(request.allHTTPHeaderFields)

                let response = HTTPURLResponse(url: exampleURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, Data())
            }

            // Save a CoreML file to the Application Support directory on the simulator for the duration of this test
            saveCoreMLModelToSimulator(name: classifierID, modelURL: watson_sample.urlOfModelInThisBundle)
            defer {
                deleteLocalCoreMLModels(classifierIDs: [classifierID])
            }

            let classifierExpectation = self.expectation(description: "getClassifier() should get called")
            let visualRecognition = MockVisualRecognition(version: versionDate, accessToken: accessToken, expectation: classifierExpectation)
            createMockSession(for: visualRecognition)

            // If there is a newer version of the CoreML model available in the VisualRecognition service,
            // it should be downloaded to replace the local outdated model.
            let expectation = self.expectation(description: "updateLocalModel with outdated model")
            visualRecognition.updateLocalModel(classifierID: classifierID) {
                _, _ in
                expectation.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }

    func testUpdateLocalModelWithUpToDateModel() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let classifierID = "watson_sample"

            // Pretend that the VR service has a newly-retrained version of the CoreML model
            class MockVisualRecognition: VisualRecognition {

                let expectation: XCTestExpectation

                init(version: String, accessToken: String, expectation: XCTestExpectation) {
                    self.expectation = expectation
                    super.init(version: version, accessToken: accessToken)
                }

                override func getClassifier(
                    classifierID: String,
                    headers: [String: String]?,
                    completionHandler: @escaping (RestResponse<Classifier>?, WatsonError?) -> Void) {

                    expectation.fulfill()

                    let oldDate = Date(timeIntervalSinceReferenceDate: 0)
                    var response: RestResponse<Classifier> = RestResponse(statusCode: 200)
                    response.result = Classifier(
                        classifierID: classifierID,
                        name: classifierID,
                        owner: nil,
                        status: "ready",
                        coreMLEnabled: true,
                        explanation: nil,
                        created: nil,
                        classes: nil,
                        retrained: oldDate,
                        updated: nil)
                    completionHandler(response, nil)
                }
            }

            // Save a CoreML file to the Application Support directory on the simulator for the duration of this test
            saveCoreMLModelToSimulator(name: classifierID, modelURL: watson_sample.urlOfModelInThisBundle)
            defer {
                deleteLocalCoreMLModels(classifierIDs: [classifierID])
            }

            let classifierExpectation = self.expectation(description: "getClassifier() should get called")
            let visualRecognition = MockVisualRecognition(version: versionDate, accessToken: accessToken, expectation: classifierExpectation)
            createMockSession(for: visualRecognition)

            // If the local copy of the CoreML model is at least as updated as
            // the model available in the VisualRecognition service, then there is no need to download.
            let expectation = self.expectation(description: "updateLocalModel with up to date model")
            visualRecognition.updateLocalModel(classifierID: classifierID) {
                response, error in
                XCTAssertNil(response)
                XCTAssertNil(error)
                expectation.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }

    func testListLocalModels() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            // Save 2 Core ML models first
            let toolsClassifierID = "watson_tools"
            let sampleClassifierID = "watson_sample"

            // Save 2 CoreML files to the Application Support directory on the simulator for the duration of this test
            saveCoreMLModelToSimulator(name: toolsClassifierID, modelURL: watson_tools.urlOfModelInThisBundle)
            saveCoreMLModelToSimulator(name: sampleClassifierID, modelURL: watson_sample.urlOfModelInThisBundle)
            defer {
                deleteLocalCoreMLModels(classifierIDs: [toolsClassifierID, sampleClassifierID])
            }

            // Then check if we can retrieve those models
            do {
                let localModels = try visualRecognition.listLocalModels()
                XCTAssertTrue(localModels.contains(toolsClassifierID))
                XCTAssertTrue(localModels.contains(sampleClassifierID))
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testClassifyWithLocalModel() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let classifierIDs = ["watson_tools"]

            // Save a CoreML file to the Application Support directory on the simulator for the duration of this test
            saveCoreMLModelToSimulator(name: classifierIDs.first!, modelURL: watson_tools.urlOfModelInThisBundle)
            defer {
                deleteLocalCoreMLModels(classifierIDs: classifierIDs)
            }

            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertEqual(request.url?.lastPathComponent, "classify")
                XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
                XCTAssertNotNil(request.httpBodyStream)
                XCTAssertNotNil(request.allHTTPHeaderFields)

                let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
                XCTAssertEqual(bodyFieldsCount, 4)

                return (dummyResponse, Data())
            }

            let expectation = self.expectation(description: "classifyWithLocalModel")
            visualRecognition.classifyWithLocalModel(imageData: car, classifierIDs: classifierIDs, threshold: 1.0) {
                _, _ in
                expectation.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }

    // Check that error handling is correct when the download
    // fails to download a CoreML model or fails to save the downloaded CoreML model
    func testDownloadClassifierWithoutCoreMLModel() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let classifierID = "watson_tools"

            // Save a CoreML file to the Application Support directory on the simulator for the duration of this test
            saveCoreMLModelToSimulator(name: classifierID, modelURL: watson_tools.urlOfModelInThisBundle)
            defer {
                deleteLocalCoreMLModels(classifierIDs: [classifierID])
            }

            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.httpMethod, "GET")
                let endOfURL = request.url!.pathComponents.suffix(3)
                XCTAssertEqual(endOfURL[endOfURL.startIndex], "classifiers")
                XCTAssertEqual(endOfURL[endOfURL.startIndex + 1], classifierID)
                XCTAssertEqual(endOfURL[endOfURL.startIndex + 2], "core_ml_model")
                XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
                XCTAssertNil(request.httpBodyStream)
                XCTAssertNotNil(request.allHTTPHeaderFields)

                let response = HTTPURLResponse(url: exampleURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
                // The download receives empty Data() instead of a CoreML model
                return (response, Data())
            }

            let expectation = self.expectation(description: "downloadClassifier without CoreML model")
            visualRecognition.downloadClassifier(classifierID: classifierID) {
                _, error in

                if case .some(WatsonError.other(let message, _)) = error,
                    let errorMessage = message {
                    XCTAssertTrue(errorMessage.contains("Could not compile Core ML model from source"))
                } else {
                    XCTFail(missingErrorMessage)
                }
                expectation.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }

    // MARK: Helpers

    // Save a sample CoreML file to the Application Support directory on the simulator
    @available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *)
    func saveCoreMLModelToSimulator(name: String, modelURL: URL) {
        do {
            let fileManager = FileManager.default
            guard let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                XCTFail("Failed to access Application Support directory")
                return
            }
            let newLocation = appSupport.appendingPathComponent(name + ".mlmodelc", isDirectory: false)
            try fileManager.copyItem(at: modelURL, to: newLocation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    // Delete CoreML files from the Application Support directory on the simulator
    @available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *)
    func deleteLocalCoreMLModels(classifierIDs: [String]) {
        do {
            try classifierIDs.forEach { classifierID in
                try visualRecognition.deleteLocalModel(classifierID: classifierID)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    // MARK: - VisualRecognition+UIImage

    func testClassifyWithImage() {
        let owners = ["Anthony", "Mike"]
        let classifierIDs = ["1", "2"]
        let image = UIImage(data: car)!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.lastPathComponent, "classify")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
            XCTAssertEqual(bodyFieldsCount, 4)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "classifyWithImage")
        visualRecognition.classify(image: image, threshold: 1.0, owners: owners, classifierIDs: classifierIDs, acceptLanguage: "en") {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testDetectFacesWithImage() {
        let image = UIImage(data: obama)!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.lastPathComponent, "detect_faces")
            XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
            XCTAssertNotNil(request.httpBodyStream)
            XCTAssertNotNil(request.allHTTPHeaderFields)

            let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
            XCTAssertEqual(bodyFieldsCount, 1)

            return (dummyResponse, Data())
        }

        let expectation = self.expectation(description: "detectFacesWithImage")
        visualRecognition.detectFaces(image: image) {
            _, _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func testClassifyWithLocalModelUIImage() {
        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
            let classifierIDs = ["1"]
            let image = UIImage(data: car)!

            MockURLProtocol.requestHandler = { request in
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertEqual(request.url?.lastPathComponent, "classify")
                XCTAssertTrue(request.url?.query?.contains("version=\(versionDate)") ?? false)
                XCTAssertNotNil(request.httpBodyStream)
                XCTAssertNotNil(request.allHTTPHeaderFields)

                let bodyFieldsCount = numberOfFieldsInMultiPartFormBody(request: request)
                XCTAssertEqual(bodyFieldsCount, 4)

                return (dummyResponse, Data())
            }

            let expectation = self.expectation(description: "classifyWithLocalModel using UIImage")
            visualRecognition.classifyWithLocalModel(image: image, classifierIDs: classifierIDs, threshold: 1.0) {
                _, _ in
                expectation.fulfill()
            }
            waitForExpectations(timeout: timeout)
        }
    }

#endif

}
