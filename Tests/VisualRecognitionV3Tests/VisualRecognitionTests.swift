/**
 * (C) Copyright IBM Corp. 2016, 2019.
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
// Do not import @testable to ensure only public interface is exposed
import VisualRecognitionV3

class VisualRecognitionTests: XCTestCase {

    private static let timeout: TimeInterval = 45.0

    private var visualRecognition: VisualRecognition!
    private let classifierID = WatsonCredentials.VisualRecognitionClassifierID

    static var allTests: [(String, (VisualRecognitionTests) -> () throws -> Void)] {
        let tests: [(String, (VisualRecognitionTests) -> () throws -> Void)] = [
            // Classifiers CRUD
            ("testListClassifiers", testListClassifiers),
            ("testListClassifiersVerbose", testListClassifiersVerbose),
            ("testCreateDeleteClassifier1", testCreateDeleteClassifier1),
            ("testCreateDeleteClassifier2", testCreateDeleteClassifier2),
            ("testGetClassifier", testGetClassifier),
            // disabled: ("testUpdateClassifierWithPositiveExample", testUpdateClassifierWithPositiveExample),
            // disabled: ("testUpdateClassifierWithNegativeExample", testUpdateClassifierWithNegativeExample),
            ("testGetCoreMlModel", testGetCoreMlModel),
            // Classify
            ("testClassifyByURL1", testClassifyByURL1),
            ("testClassifyByURL2", testClassifyByURL2),
            ("testClassifyByURL3", testClassifyByURL3),
            ("testClassifyByURL4", testClassifyByURL4),
            ("testClassifyByURL5", testClassifyByURL5),
            ("testClassifyImage1", testClassifyImage1),
            ("testClassifyImage2", testClassifyImage2),
            ("testClassifyImage3", testClassifyImage3),
            ("testClassifyImage4", testClassifyImage4),
            ("testClassifyImage5", testClassifyImage5),
            ("testClassifyImage6", testClassifyImage6),
            // Negative tests
            ("testCreateClassifierWithInvalidPositiveExamples", testCreateClassifierWithInvalidPositiveExamples),
            ("testClassifyByInvalidURL", testClassifyByInvalidURL),
            ("testGetUnknownClassifier", testGetUnknownClassifier),
        ]
        return tests
    }

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
    }

    /** Instantiate Visual Recognition. */
    func instantiateVisualRecognition() {
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.VisualRecognitionV3APIKey)
        visualRecognition = VisualRecognition(version: versionDate, authenticator: authenticator)
        if let url = WatsonCredentials.VisualRecognitionURL {
            visualRecognition.serviceURL = url
        }
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = timeout) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Classifiers CRUD

    /** Retrieve a list of user-trained classifiers. */
    func testListClassifiers() {
        let expectation = self.expectation(description: "Retrieve a list of user-trained classifiers.")

        visualRecognition.listClassifiers { response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiers = response?.result?.classifiers else {
                XCTFail(missingResultMessage)
                return
            }
            for classifier in classifiers where classifier.classifierID == self.classifierID {
                expectation.fulfill()
                return
            }
            XCTFail("Could not retrieve the trained classifier.")
        }
        waitForExpectations()
    }

    /** Retrieve a verbose list of user-trained classifiers. */
    func testListClassifiersVerbose() {
        let expectation = self.expectation(description: "Retrieve a list of user-trained classifiers.")

        visualRecognition.listClassifiers(verbose: true) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiers = response?.result?.classifiers else {
                XCTFail(missingResultMessage)
                return
            }
            for classifier in classifiers where classifier.classifierID == self.classifierID {
                expectation.fulfill()
                return
            }
            XCTFail("Could not retrieve the trained classifier.")
        }
        waitForExpectations()
    }

    /** Train a classifier with only positive examples. */
    func testCreateDeleteClassifier1() {
        let name = "swift-sdk-unit-test-1"
        let classes = ["baseball": baseball, "cars": cars, "trucks": trucks]

        var classifierID: String?
        let expectation1 = expectation(description: "Train a classifier with only positive examples.")
        visualRecognition.createClassifier(name: name, positiveExamples: classes) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifier = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(classifier.name, name)
            XCTAssertNotNil(classifier.classes)
            XCTAssertEqual(classifier.classes!.count, 3)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let classifierIDToDelete = classifierID else {
            return
        }

        let expectation2 = expectation(description: "Check that our classifier can be retrieved.")
        visualRecognition.listClassifiers(verbose: true) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiers = response?.result?.classifiers else {
                XCTFail(missingResultMessage)
                return
            }
            for classifier in classifiers where classifier.classifierID == classifierIDToDelete {
                expectation2.fulfill()
                return
            }
            XCTFail("The created classifier could not be retrieved from the service.")
        }
        waitForExpectations()

        // allow zip files to propagate through object storage, so that
        // they will be deleted when the service deletes the classifier
        // (otherwise they remain and dramatically slow down the tests)
        sleep(15) // wait 15 seconds

        let expectation3 = expectation(description: "Delete the custom classifier.")
        visualRecognition.deleteClassifier(classifierID: classifierIDToDelete) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Train a classifier with both positive and negative examples. */
    func testCreateDeleteClassifier2() {
        let name = "swift-sdk-unit-test-2"

        var classifierID: String?
        let expectation1 = expectation(description: "Train a classifier with both positive and negative examples.")
        visualRecognition.createClassifier(
            name: name,
            positiveExamples: ["cars": cars],
            negativeExamples: trucks) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertEqual(classifier.name, name)
                XCTAssertNotNil(classifier.classes)
                XCTAssertEqual(classifier.classes!.count, 1)
                classifierID = classifier.classifierID
                expectation1.fulfill()
        }
        waitForExpectations()

        guard let newClassifierID = classifierID else {
            XCTFail("Failed to create a new classifier due to free account.")
            return
        }

        let expectation2 = expectation(description: "Check that our classifier can be retrieved.")
        visualRecognition.listClassifiers(verbose: true) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiers = response?.result?.classifiers else {
                XCTFail(missingResultMessage)
                return
            }
            for classifier in classifiers where classifier.classifierID == newClassifierID {
                expectation2.fulfill()
                return
            }
            XCTFail("The created classifier could not be retrieved from the service.")
        }
        waitForExpectations()

        // allow zip files to propagate through object storage, so that
        // they will be deleted when the service deletes the classifier
        // (otherwise they remain and dramatically slow down the tests)
        sleep(15) // wait 15 seconds

        let expectation3 = expectation(description: "Delete the custom classifier.")
        visualRecognition.deleteClassifier(classifierID: newClassifierID) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Get information about the trained classifier. */
    func testGetClassifier() {
        let expectation = self.expectation(description: "Get information about the trained classifier.")
        visualRecognition.getClassifier(classifierID: classifierID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifier = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertNotNil(classifier.classes)
            XCTAssertEqual(classifier.classes!.count, 2)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Update the classifier with a positive example. */
    func testUpdateClassifierWithPositiveExample() {
        let name = "swift-sdk-unit-test-positive-update"

        var classifierID: String?
        let expectation1 = expectation(description: "Train a new classifier with positive examples.")
        visualRecognition.createClassifier(
            name: name,
            positiveExamples: ["cars": cars],
            negativeExamples: baseball) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertEqual(classifier.name, name)
                XCTAssertNotNil(classifier.classes)
                XCTAssertEqual(classifier.classes!.count, 1)
                classifierID = classifier.classifierID
                expectation1.fulfill()
        }
        waitForExpectations()

        guard let newClassifierID = classifierID else {
            XCTFail("Failed to create a new classifier due to free account.")
            return
        }

        // Teardown logic has been moved to teardown class method

        var trained = false
        var tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the new classifier.")
            visualRecognition.getClassifier(classifierID: newClassifierID) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                if classifier.status == "ready" {
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()

            tries += 1
            if tries > 8 {
                XCTFail("Could not train a new classifier. Try again later.")
                return
            }
        }

        let expectation2 = expectation(description: "Update the classifier with a positive example.")

        visualRecognition.updateClassifier(
            classifierID: newClassifierID,
            positiveExamples: ["trucks": trucks]) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertEqual(classifier.name, name)
                expectation2.fulfill()
        }
        waitForExpectations()

        trained = false
        tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the updated classifier.")
            visualRecognition.getClassifier(classifierID: newClassifierID) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                if classifier.status == "ready" {
                    XCTAssertNotNil(classifier.classes)
                    XCTAssertEqual(classifier.classes!.count, 2)
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()

            tries += 1
            if tries > 8 {
                XCTFail("Could not update the classifier. Try again later.")
                return
            }
        }
    }

    /** Update the classifier with a negative example. */
    func testUpdateClassifierWithNegativeExample() {
        let expectation1 = expectation(description: "Train a new classifier with positive examples.")

        let name = "swift-sdk-unit-test-negative-update"

        var classifierID: String?
        visualRecognition.createClassifier(
            name: name,
            positiveExamples: ["cars": cars],
            negativeExamples: trucks) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertEqual(classifier.name, name)
                XCTAssertNotNil(classifier.classes)
                XCTAssertEqual(classifier.classes!.count, 1)
                classifierID = classifier.classifierID
                expectation1.fulfill()
        }
        waitForExpectations()

        guard let newClassifierID = classifierID else {
            XCTFail("Failed to create a new classifier due to free account.")
            return
        }

        // Teardown logic has been moved to teardown class method

        var trained = false
        var tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the new classifier.")
            visualRecognition.getClassifier(classifierID: newClassifierID) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                if classifier.status == "ready" {
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()

            tries += 1
            if tries > 8 {
                 XCTFail("Could not train a new classifier. Try again later.")
                return
            }
        }

        let expectation2 = expectation(description: "Update the classifier with a negative example.")
        visualRecognition.updateClassifier(
            classifierID: newClassifierID,
            negativeExamples: baseball) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertEqual(classifier.name, name)
                expectation2.fulfill()
        }
        waitForExpectations()

        trained = false
        tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the updated classifier.")
            visualRecognition.getClassifier(classifierID: newClassifierID) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let classifier = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                if classifier.status == "ready" {
                    XCTAssertNotNil(classifier.classes)
                    XCTAssertEqual(classifier.classes!.count, 1)
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()

            tries += 1
            if tries > 8 {
                XCTFail("Could not update the classifier. Try again later.")
                return
            }
        }
    }

    /** Get the Core ML model for a trained classifier. */
    func testGetCoreMlModel() {
        let expectation = self.expectation(description: "Get the Core ML model for a trained classifier.")
        visualRecognition.getCoreMLModel(classifierID: classifierID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let coreMLModel = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(coreMLModel)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Classify

    /** Classify an image by URL using the default classifier and all default parameters. */
    func testClassifyByURL1() {
        let expectation = self.expectation(description: "Classify an image by URL")

        visualRecognition.classify(url: obamaURL, acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            var containsPersonClass = false
            var classifierScore: Double?

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, obamaURL)
            XCTAssertEqual(image?.resolvedURL, obamaURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")

            guard let classes = classifier?.classes else {
                XCTFail("Did not return any classes")
                return
            }
            XCTAssertGreaterThan(classes.count, 0)
            for cls in classes where cls.class == "person" {
                containsPersonClass = true
                classifierScore = cls.score
                break
            }
            XCTAssertEqual(true, containsPersonClass)
            if let score = classifierScore {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an image by URL using the default classifier and specifying default parameters. */
    func testClassifyByURL2() {
        let expectation = self.expectation(description: "Classify an image by URL using the default classifier.")
        visualRecognition.classify(
            url: obamaURL,
            threshold: 0.5,
            owners: ["IBM"],
            classifierIDs: ["default"],
            acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            var containsPersonClass = false
            var classifierScore: Double?

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, obamaURL)
            XCTAssertEqual(image?.resolvedURL, obamaURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")
            guard let classes = classifier?.classes else {
                XCTFail("Did not return any classes.")
                return
            }
            XCTAssertGreaterThan(classes.count, 0)
            for cls in classes where cls.class == "person" {
                containsPersonClass = true
                classifierScore = cls.score
                break
            }
            XCTAssertEqual(containsPersonClass, true)
            if let score = classifierScore {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an image by URL using a custom classifier and all default parameters. */
    func testClassifyByURL3() {
        let expectation = self.expectation(description: "Classify an image by URL using a custom classifier.")
        visualRecognition.classify(
            url: carURL,
            classifierIDs: [classifierID],
            acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, carURL)
            XCTAssertEqual(image?.resolvedURL, carURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, self.classifierID)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.class, "turtle")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an image by URL using a custom classifier and specifying default parameters. */
    func testClassifyByURL4() {
        let expectation = self.expectation(description: "Classify an image by URL using a custom classifier.")
        visualRecognition.classify(
            url: carURL,
            threshold: 0.5,
            owners: ["me"],
            classifierIDs: [classifierID],
            acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, carURL)
            XCTAssertEqual(image?.resolvedURL, carURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, self.classifierID)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.class, "turtle")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an image by URL with both the default classifier and a custom classifier. */
    func testClassifyByURL5() {
        let expectation = self.expectation(description: "Classify an image by URL using a custom classifier.")
        visualRecognition.classify(url: carURL, classifierIDs: ["default", classifierID]) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, carURL)
            XCTAssertEqual(image?.resolvedURL, carURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)

            // verify 2 classifiers are returned
            guard let classifiers = image?.classifiers else {
                XCTFail("No classifiers found")
                return
            }

            for classifier in classifiers {
                var classifierScore: Double?
                // verify the image's default classifier
                if classifier.name == "default" {
                    XCTAssertEqual(classifier.classifierID, "default")
                    XCTAssertEqual(classifier.name, "default")

                    XCTAssertGreaterThan(classifier.classes.count, 0)
                    for cls in classifier.classes where cls.class == "car" {
                        classifierScore = cls.score
                    }

                    if let score = classifierScore {
                        XCTAssertGreaterThan(score, 0.5)
                    }
                } else {
                    // verify the image's custom classifier
                    XCTAssertEqual(classifier.classifierID, self.classifierID)
                    XCTAssertEqual(classifier.classes.count, 1)
                    XCTAssertEqual(classifier.classes.first?.class, "turtle")
                    if let score = classifier.classes.first?.score {
                        XCTAssertGreaterThan(score, 0.5)
                    }
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an uploaded image using the default classifier and all default parameters. */
    func testClassifyImage1() {
        let expectation = self.expectation(description: "Classify an uploaded image using the default classifier.")
        visualRecognition.classify(imagesFile: car, imagesFilename: "car.png", acceptLanguage: "en") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            var containsPersonClass = false
            var classifierScore: Double?
            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssert(image?.image == "car.png")
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")
            guard let classes = classifier?.classes else {
                XCTFail("Did not return any classes")
                return
            }
            XCTAssertGreaterThan(classes.count, 0)
            for cls in classes where cls.class == "car" {
                containsPersonClass = true
                classifierScore = cls.score
                break
            }
            XCTAssertEqual(true, containsPersonClass)
            if let score = classifierScore {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an uploaded image using the default classifier and specifying default parameters. */
    func testClassifyImage2() {
        let expectation = self.expectation(description: "Classify an uploaded image using the default classifier.")
        visualRecognition.classify(
            imagesFile: car,
            imagesFilename: "car.png",
            threshold: 0.5,
            owners: ["IBM"],
            classifierIDs: ["default"]) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            var containsPersonClass = false
            var classifierScore: Double?

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssert(image?.image == "car.png")
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")
            guard let classes = classifier?.classes else {
                XCTFail("Did not return any classes.")
                return
            }
            XCTAssertGreaterThan(classes.count, 0)
            for cls in classes where cls.class == "car" {
                containsPersonClass = true
                classifierScore = cls.score
                break
            }
            XCTAssertEqual(containsPersonClass, true)
            if let score = classifierScore {
                XCTAssertGreaterThan(score, 0.5)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an uploaded image using a custom classifier and all default parameters. */
    func testClassifyImage3() {
        let expectation = self.expectation(description: "Classify an uploaded image using a custom classifier.")
        visualRecognition.classify(
            imagesFile: car,
            imagesFilename: "car.png",
            classifierIDs: [classifierID]) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssert(image?.image == "car.png")
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, self.classifierID)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.class, "turtle")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an uploaded image using a custom classifier and specifying default parameters. */
    func testClassifyImage4() {
        let expectation = self.expectation(description: "Classify an uploaded image using a custom classifier.")
        visualRecognition.classify(
            imagesFile: car,
            imagesFilename: "car.png",
            threshold: 0.5,
            owners: ["me"],
            classifierIDs: [classifierID]) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssert(image?.image == "car.png")
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, self.classifierID)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.class, "turtle")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify an uploaded image with both the default classifier and a custom classifier. */
    func testClassifyImage5() {
        let expectation = self.expectation(description: "Classify an uploaded image with the default and custom classifiers.")
        visualRecognition.classify(
            imagesFile: car,
            imagesFilename: "car.png",
            classifierIDs: ["default", classifierID]) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            var containsCarClass = false
            var classifierScore: Double?

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssert(image?.image == "car.png")
            XCTAssertNil(image?.error)

            // verify 2 classifiers are returned
            guard let classifiers = image?.classifiers else {
                XCTFail("No classifiers found")
                return
            }

            for classifier in classifiers {
                // verify the image's default classifier
                if classifier.name == "default" {
                    XCTAssertEqual(classifier.classifierID, "default")
                    XCTAssertEqual(classifier.name, "default")

                    XCTAssertGreaterThan(classifier.classes.count, 0)
                    for cls in classifier.classes where cls.class == "car" {
                        containsCarClass = true
                        classifierScore = cls.score
                    }
                    XCTAssertEqual(containsCarClass, true)
                    if let score = classifierScore {
                        XCTAssertGreaterThan(score, 0.5)
                    }
                } else {
                    // verify the image's custom classifier
                    XCTAssertEqual(classifier.classifierID, self.classifierID)
                    XCTAssertEqual(classifier.classes.count, 1)
                    XCTAssertEqual(classifier.classes.first?.class, "turtle")
                    if let score = classifier.classes.first?.score {
                        XCTAssertGreaterThan(score, 0.5)
                    }
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Classify multiple images using a custom classifier. */
    func testClassifyImage6() {
        let expectation = self.expectation(description: "Classify multiple images using a custom classifier.")
        visualRecognition.classify(
            imagesFile: carz,
            imagesFilename: "cars.zip",
            classifierIDs: ["default", classifierID]) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let classifiedImages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 4)

            for image in classifiedImages.images {
                // verify the image's metadata
                XCTAssertNil(image.sourceURL)
                XCTAssertNil(image.resolvedURL)
                XCTAssert(image.image?.hasPrefix("car") == true)
                XCTAssertNil(image.error)

                for classifier in image.classifiers {
                    var containsCarClass = false
                    var classifierScore: Double?
                    if classifier.name == "default" {
                        // verify the image's default classifier
                        XCTAssertEqual(classifier.classifierID, "default")
                        XCTAssertEqual(classifier.name, "default")
                        XCTAssertGreaterThan(classifier.classes.count, 0)
                        for cls in classifier.classes {
                            let classes = ["car", "vehicle", "sedan", "Parking Garage (Indoor)"]
                            if classes.contains(cls.class) {
                                containsCarClass = true
                                classifierScore = cls.score
                            }
                        }
                        XCTAssertEqual(containsCarClass, true)
                        if let score = classifierScore {
                            XCTAssertGreaterThan(score, 0.5)
                        }
                    } else {
                        // verify the image's custom classifier
                        XCTAssertEqual(classifier.classifierID, self.classifierID)
                        if let score = classifier.classes.first?.score {
                            XCTAssertGreaterThan(score, 0.5)
                        }
                    }
                }
            }

            expectation.fulfill()
        }
        waitForExpectations(timeout: 60)
    }

    // MARK: - Negative Tests

    /** Test creating a classifier with a single image for positive examples. */
    func testCreateClassifierWithInvalidPositiveExamples() {
        let expectation = self.expectation(description: "Create classifier with invalid positive example.")

        visualRecognition.createClassifier(name: "invalidClassifier", positiveExamples: ["obama": obama]) {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Test classifying an invalid URL using the default classifier and parameters. */
    func testClassifyByInvalidURL() {
        let expectation = self.expectation(description: "Classify an image with an invalid URL.")

        let invalidImageURL = "invalid-image-url"
        visualRecognition.classify(url: invalidImageURL) {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Get information about an unknown classifier. */
    func testGetUnknownClassifier() {
        let expectation = self.expectation(description: "Get information about an unknown classifier.")

        visualRecognition.getClassifier(classifierID: "foo-bar-baz") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
