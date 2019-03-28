/**
 * Copyright IBM Corporation 2016
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
import Foundation
import NaturalLanguageClassifierV1

class NaturalLanguageClassifierTests: XCTestCase {

    // Several tests depend upon an already-trained classifier. If the classifier does not exist then use the
    // API Explorer (watson-api-explorer.mybluemix.net) to create a classifier using the `trained_meta.txt`
    // and `weather_data_train.csv` files. Be sure to update the `trainedClassifierId` property below!

    private var naturalLanguageClassifier: NaturalLanguageClassifier!
    private let trainedClassifierId = "6b5ab4x398-nlc-95"
    private let trainedClassifierName = "swift-sdk-test-classifier - DO NOT DELETE"
    private let temporaryClassifierName = "swift-sdk-temporary-classifier"

    private var metadataFile: Data!
    private var metadataFileEmpty: Data!
    private var metadataFileMissingName: Data!
    private var trainingFile: Data!

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateNaturalLanguageClassifier()
        loadClassifierFiles()
    }

    static var allTests: [(String, (NaturalLanguageClassifierTests) -> () throws -> Void)] {
        return [
            ("testCreateAndDelete", testCreateAndDelete),
            ("testCreateAndDeleteClassifierWithoutOptionalName", testCreateAndDeleteClassifierWithoutOptionalName),
            ("testListClassifiers", testListClassifiers),
            ("testGetClassifier", testGetClassifier),
            ("testClassify", testClassify),
            ("testClassifyCollection", testClassifyCollection),
            ("testCreateClassifierWithMissingMetadata", testCreateClassifierWithMissingMetadata),
            ("testClassifyEmptyString", testClassifyEmptyString),
            ("testClassifyWithInvalidClassifier", testClassifyWithInvalidClassifier),
            ("testDeleteInvalidClassifier", testDeleteInvalidClassifier),
            ("testGetInvalidClassifier", testGetInvalidClassifier),
        ]
    }

    func instantiateNaturalLanguageClassifier() {
        if let apiKey = WatsonCredentials.NaturalLanguageClassifierAPIKey {
            naturalLanguageClassifier = NaturalLanguageClassifier(apiKey: apiKey)
        } else {
            let username = WatsonCredentials.NaturalLanguageClassifierUsername
            let password = WatsonCredentials.NaturalLanguageClassifierPassword
            naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)
        }
        if let url = WatsonCredentials.NaturalLanguageClassifierURL {
            naturalLanguageClassifier.serviceURL = url
        }
        naturalLanguageClassifier.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        naturalLanguageClassifier.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 20.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Helper Functions

    func loadClassifierFiles() {
        metadataFile = loadClassifierFile(name: "training_meta", withExtension: "txt")
        metadataFileEmpty = loadClassifierFile(name: "training_meta_empty", withExtension: "txt")
        metadataFileMissingName = loadClassifierFile(name: "training_meta_missing_name", withExtension: "txt")
        trainingFile = loadClassifierFile(name: "weather_data_train", withExtension: "csv")
        guard metadataFile != nil, metadataFileEmpty != nil, metadataFileMissingName != nil, trainingFile != nil else {
            XCTFail("Failed to load files required to create a classifier.")
            return
        }
    }

    /** Load a file used when creating a classifier. */
    func loadClassifierFile(name: String, withExtension: String) -> Data? {
        #if os(Linux)
            let url = URL(fileURLWithPath: "Tests/NaturalLanguageClassifierV1Tests/" + name + "." + withExtension)
        #else
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: name, withExtension: withExtension) else { return nil }
        #endif
        let data = try? Data(contentsOf: url)
        return data
    }

    // MARK: - Positive Tests

    func testCreateAndDelete() {
        let expectation = self.expectation(description: "Create and delete a classifier")
        naturalLanguageClassifier.createClassifier(metadata: metadataFile, trainingData: trainingFile) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifier = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(classifier.name, self.temporaryClassifierName)
            XCTAssertEqual(classifier.language, "en")
            self.naturalLanguageClassifier.deleteClassifier(classifierID: classifier.classifierID) {
                _, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testCreateAndDeleteClassifierWithoutOptionalName() {
        let expectation = self.expectation(description: "Create and delete a classifier with no name.")
        naturalLanguageClassifier.createClassifier(metadata: metadataFileMissingName, trainingData: trainingFile) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifier = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(classifier.name, nil)
            XCTAssertEqual(classifier.language, "en")
            self.naturalLanguageClassifier.deleteClassifier(classifierID: classifier.classifierID) {
                _, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testListClassifiers() {
        let expectation = self.expectation(description: "Get classifiers.")
        naturalLanguageClassifier.listClassifiers {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiers = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(classifiers.classifiers.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetClassifier() {
        let expectation = self.expectation(description: "Get classifier.")
        naturalLanguageClassifier.getClassifier(classifierID: trainedClassifierId) { response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifier = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(classifier.name, self.trainedClassifierName)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassify() {
        let expectation = self.expectation(description: "Classify text.")
        naturalLanguageClassifier.classify(classifierID: trainedClassifierId, text: "How hot will it be today?") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classification = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(classification.topClass, "temperature")
            XCTAssertNotNil(classification.classes)
            XCTAssertEqual(classification.classes!.count, 2)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyCollection() {
        let expectation = self.expectation(description: "classifyCollection")
        let text1 = "How hot will it be today?"
        let text2 = "How sunny will it be today?"
        let collection = [ClassifyInput(text: text1), ClassifyInput(text: text2)]
        naturalLanguageClassifier.classifyCollection(classifierID: trainedClassifierId, collection: collection) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifications = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(classifications.classifierID)
            XCTAssertEqual(classifications.classifierID, self.trainedClassifierId)
            XCTAssertNotNil(classifications.collection)
            XCTAssertEqual(classifications.collection!.count, 2)
            XCTAssertEqual(classifications.collection![0].text, text1)
            XCTAssertEqual(classifications.collection![0].topClass, "temperature")
            XCTAssertEqual(classifications.collection![1].text, text2)
            XCTAssertEqual(classifications.collection![1].topClass, "conditions")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testCreateClassifierWithMissingMetadata() {
        let expectation = self.expectation(description: "Create a classifier with missing metadata")
        naturalLanguageClassifier.createClassifier(
            metadata: metadataFileEmpty,
            trainingData: trainingFile
        ) {
                _, error in

                if error == nil {
                    XCTFail(missingErrorMessage)
                }
                expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyEmptyString() {
        let expectation = self.expectation(description: "Classify and empty string.")
        naturalLanguageClassifier.classify(classifierID: trainedClassifierId, text: "") {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testClassifyWithInvalidClassifier() {
        let expectation = self.expectation(description: "Classify using an invalid classifier id.")
        naturalLanguageClassifier.classify(
            classifierID: "this-is-an-invalid-classifier-id",
            text: "How hot will it be today?"
        ) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDeleteInvalidClassifier() {
        let expectation = self.expectation(description: "Delete a classifier using an invalid classifier id.")
        naturalLanguageClassifier.deleteClassifier(
            classifierID: "this-is-an-invalid-classifier-id"
        ) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetInvalidClassifier() {
        let expectation = self.expectation(description: "Get classifier using an invalid classifier id.")
        naturalLanguageClassifier.getClassifier(
            classifierID: "this-is-an-invalid-classifier-id"
        ) {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
