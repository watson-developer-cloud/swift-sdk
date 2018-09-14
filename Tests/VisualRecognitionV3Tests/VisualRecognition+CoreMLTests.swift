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

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)

import XCTest
import VisualRecognitionV3

class VisualRecognitionCoreMLTests: XCTestCase {

    private var visualRecognition: VisualRecognition!
    private let timeout: TimeInterval = 30.0
    private let classifierID = WatsonCredentials.VisualRecognitionClassifierID

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
    }

    /** Instantiate Visual Recognition */
    func instantiateVisualRecognition() {
        let version = "2018-09-14"
        if let apiKey = WatsonCredentials.VisualRecognitionAPIKey {
            visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
        } else {
            let apiKey = WatsonCredentials.VisualRecognitionLegacyAPIKey
            visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        }
        if let url = WatsonCredentials.VisualRecognitionURL {
            visualRecognition.serviceURL = url
        }
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    /** Test local model file management. */
    func testLocalModelCRUD() {
        if #available(iOS 11.0, *) {

            // update the local model
            let expectation = self.expectation(description: "updateLocalModel")
            visualRecognition.updateLocalModel(classifierID: classifierID, failure: failWithError) {
                expectation.fulfill()
            }
            waitForExpectations()

            // get the local model
            guard (try? visualRecognition.getLocalModel(classifierID: classifierID)) != nil else {
                XCTFail("Failed to get the local model after it was updated.")
                return
            }

            // list the local models
            guard let localModels = try? visualRecognition.listLocalModels() else {
                XCTFail("Failed to list the local models")
                return
            }

            // ensure the model is included in list of local models
            XCTAssertEqual(localModels.count, 1)
            XCTAssert(localModels.contains(classifierID))

            // delete the local model
            guard (try? visualRecognition.deleteLocalModel(classifierID: classifierID)) != nil else {
                XCTFail("Failed to delete the local model.")
                return
            }

            // ensure that errors are thrown when the model is not present
            XCTAssertThrowsError(try visualRecognition.getLocalModel(classifierID: classifierID))
            XCTAssertThrowsError(try visualRecognition.deleteLocalModel(classifierID: classifierID))

            // ensure that no models are listed when not present
            guard let emptyModels = try? visualRecognition.listLocalModels() else {
                XCTFail("Failed to list the local models")
                return
            }
            XCTAssertEqual(emptyModels.count, 0)

        } else {
            XCTFail("Core ML requires iOS 11+")
        }
    }

    func testClassifyWithLocalModel() throws {
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {

            // update the local model
            let expectation1 = self.expectation(description: "updateLocalModel")
            visualRecognition.updateLocalModel(classifierID: classifierID, failure: failWithError) {
                expectation1.fulfill()
            }
            waitForExpectations()

            // convert imageFile to Data
            let bundle = Bundle(for: type(of: self))
            let imageFile = bundle.url(forResource: "car", withExtension: "png")!
            let imageData = try Data(contentsOf: imageFile)

            // classify using the local model
            let expectation2 = self.expectation(description: "classifyWithLocalModel")
            visualRecognition.classifyWithLocalModel(imageData: imageData, classifierIDs: [classifierID], threshold: 0.1, failure: failWithError) {
                classifiedImages in
                print(classifiedImages)
                expectation2.fulfill()
            }
            waitForExpectations()

            // delete the local model
            do {
                try visualRecognition.deleteLocalModel(classifierID: classifierID)
            } catch {
                XCTFail("Failed to delete the local model: \(error)")
            }

        } else {
            XCTFail("Core ML required iOS 11+")
        }
    }
}

#endif
