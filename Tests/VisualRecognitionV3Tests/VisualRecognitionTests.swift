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

// swiftlint:disable function_body_length force_try force_unwrapping superfluous_disable_command

import XCTest
import Foundation
import VisualRecognitionV3

class VisualRecognitionTests: XCTestCase {

    private var visualRecognition: VisualRecognition!
    private let classifierName = "swift-sdk-unit-test-cars-trucks"
    private let collectionName = "swift-sdk-unit-test-faces"
    private var classifierID: String?
    private var imageFaceID: String?

    static var allTests: [(String, (VisualRecognitionTests) -> () throws -> Void)] {
        return [
            ("testGetClassifiers", testGetClassifiers),
            ("testCreateDeleteClassifier1", testCreateDeleteClassifier1),
            ("testCreateDeleteClassifier2", testCreateDeleteClassifier2),
            ("testGetClassifier", testGetClassifier),
            ("testUpdateClassifierWithPositiveExample", testUpdateClassifierWithPositiveExample),
            ("testUpdateClassifierWithNegativeExample", testUpdateClassifierWithNegativeExample),
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
            ("testDetectFacesByURL", testDetectFacesByURL),
            ("testDetectFacesByImage1", testDetectFacesByImage1),
            ("testDetectFacesByImage2", testDetectFacesByImage2),
            ("testCreateClassifierWithInvalidPositiveExamples", testCreateClassifierWithInvalidPositiveExamples),
            ("testClassifyByInvalidURL", testClassifyByInvalidURL),
            ("testDetectFacesByInvalidURL", testDetectFacesByInvalidURL),
        ]
    }

    private var examplesBaseball: URL!
    private var examplesCars: URL!
    private var examplesTrucks: URL!
    private var faces: URL!
    private var face1: URL!
    private var car: URL!
    private var carz: URL!
    private var obama: URL!
    private var sign: URL!

    private let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
                           "Administration/People/president_official_portrait_lores.jpg"
    private let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk" +
                         "/master/visual-recognition/src/test/resources/visual_recognition/car.png"
    private let signURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk/" +
                          "master/visual-recognition/src/test/resources/visual_recognition/open.png"

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
        loadImageFiles()
        lookupClassifier()
    }

    /** Instantiate Visual Recognition. */
    func instantiateVisualRecognition() {
        let apiKey = Credentials.VisualRecognitionAPIKey
        let version = "2016-11-04"
        visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        visualRecognition.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        visualRecognition.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Load image files with class examples and test images. */
    func loadImageFiles() {

        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard
                let examplesBaseball =  bundle.url(forResource: "baseball", withExtension: "zip"),
                let examplesCars =      bundle.url(forResource: "cars", withExtension: "zip"),
                let examplesTrucks =    bundle.url(forResource: "trucks", withExtension: "zip"),
                let faces =             bundle.url(forResource: "faces", withExtension: "zip"),
                let face1 =             bundle.url(forResource: "face1", withExtension: "jpg"),
                let car =               bundle.url(forResource: "car", withExtension: "png"),
                let carz =              bundle.url(forResource: "carz", withExtension: "zip"),
                let obama =             bundle.url(forResource: "obama", withExtension: "jpg"),
                let sign =              bundle.url(forResource: "sign", withExtension: "jpg")
                else {
                    XCTFail("Unable to locate sample image files.")
                    return
            }
        #else
            let examplesBaseball =  URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Classes/baseball.zip")
            let examplesCars =      URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Classes/cars.zip")
            let examplesTrucks =    URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Classes/trucks.zip")
            let faces =             URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Images/faces.zip")
            let face1 =             URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Images/face1.jpg")
            let car =               URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Images/car.png")
            let carz =              URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Images/carz.zip")
            let obama =             URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Images/obama.jpg")
            let sign =              URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/Images/sign.jpg")
        #endif

        self.examplesBaseball = examplesBaseball
        self.examplesCars = examplesCars
        self.examplesTrucks = examplesTrucks
        self.faces = faces
        self.face1 = face1
        self.car = car
        self.carz = carz
        self.obama = obama
        self.sign = sign
    }

    /** Look up (or create) the trained classifier. */
    func lookupClassifier() {
        let expectation = self.expectation(description: "Look up (or create) the trained classifier.")

        let failure = { (error: Error) in
            XCTFail("Failed to locate the trained classifier.")
        }

        visualRecognition.getClassifiers(failure: failure) { classifiers in
            for classifier in classifiers where classifier.name == self.classifierName {
                XCTAssert(classifier.status == "ready", "Wait for training to complete.")
                self.classifierID = classifier.classifierID
                expectation.fulfill()
                return
            }
            expectation.fulfill()
        }
        waitForExpectations()

        if classifierID == nil {
            trainClassifier()
        }
    }

    /** Train a classifier for the test suite. */
    func trainClassifier() {
        let expectation = self.expectation(description: "Train a classifier for the test suite.")

        let car = PositiveExample(name: "car", examples: examplesCars)
        let failure = { (error: Error) in XCTFail("Could not train classifier for test suite.") }
        visualRecognition.createClassifier(
            withName: classifierName,
            positiveExamples: [car],
            negativeExamples: examplesTrucks,
            failure: failure) { classifier in
                self.classifierID = classifier.classifierID
                expectation.fulfill()
        }
        waitForExpectations()

        XCTFail("Training a classifier for the test suite. Try again in 10 seconds.")
    }

    /** Load file used when adding metadata to an image. */
    func loadMetadataFile(withName name: String, withExtension: String) -> URL? {

        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: name, withExtension: withExtension) else {
                return nil
            }
        #else
            let url = URL(fileURLWithPath: "Tests/VisualRecognitionV3Tests/"+name+"."+withExtension)
        #endif

        return url
    }

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    /** Fail false positives. */
    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 45.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    /** Retrieve a list of user-trained classifiers. */
    func testGetClassifiers() {
        let expectation = self.expectation(description: "Retrieve a list of user-trained classifiers.")

        visualRecognition.getClassifiers(failure: failWithError) { classifiers in
            for classifier in classifiers {
                let idMatch = (classifier.classifierID == self.classifierID)
                let nameMatch = (classifier.name == self.classifierName)
                if idMatch && nameMatch {
                    expectation.fulfill()
                    return
                }
            }
            XCTFail("Could not retrieve the trained classifier.")
        }
        waitForExpectations()
    }

    /** Train a classifier with only positive examples. */
    func testCreateDeleteClassifier1() {
        let name = "swift-sdk-unit-test-1"
        let baseball = PositiveExample(name: "baseball", examples: examplesBaseball)
        let cars = PositiveExample(name: "car", examples: examplesCars)
        let trucks = PositiveExample(name: "truck", examples: examplesTrucks)
        let classes = [baseball, cars, trucks]

        var classifierID: String?
        let expectation1 = expectation(description: "Train a classifier with only positive examples.")
        visualRecognition.createClassifier(withName: name, positiveExamples: classes, failure: failWithError) {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 3)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let classifierIDToDelete = classifierID else {
            return
        }

        let expectation2 = expectation(description: "Check that our classifier can be retrieved.")
        visualRecognition.getClassifiers(failure: failWithError) { classifiers in
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
        visualRecognition.deleteClassifier(withID: classifierIDToDelete, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Train a classifier with both positive and negative examples. */
    func testCreateDeleteClassifier2() {
        let name = "swift-sdk-unit-test-2"
        let cars = PositiveExample(name: "car", examples: examplesCars)

        var classifierID: String?
        let expectation1 = expectation(description: "Train a classifier with both positive and negative examples.")
        visualRecognition.createClassifier(
            withName: name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                XCTAssertEqual(classifier.classes.count, 1)
                classifierID = classifier.classifierID
                expectation1.fulfill()
        }
        waitForExpectations()

        guard let newClassifierID = classifierID else {
            XCTFail("Failed to create a new classifier due to free account.")
            return
        }

        let expectation2 = expectation(description: "Check that our classifier can be retrieved.")
        visualRecognition.getClassifiers(failure: failWithError) { classifiers in
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
        visualRecognition.deleteClassifier(withID: newClassifierID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }

    /** Get information about the trained classifier. */
    func testGetClassifier() {
        let expectation = self.expectation(description: "Get information about the trained classifier.")
        visualRecognition.getClassifier(withID: classifierID!, failure: failWithError) {
            classifier in
            XCTAssertEqual(classifier.name, self.classifierName)
            XCTAssertEqual(classifier.classes.count, 1)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Update the classifier with a positive example. */
    func testUpdateClassifierWithPositiveExample() {
        let name = "swift-sdk-unit-test-positive-update"
        let cars = PositiveExample(name: "car", examples: examplesCars)
        let trucks = PositiveExample(name: "truck", examples: examplesTrucks)

        var classifierID: String?
        let expectation1 = expectation(description: "Train a new classifier with positive examples.")
        visualRecognition.createClassifier(
            withName: name,
            positiveExamples: [cars],
            negativeExamples: examplesBaseball,
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                XCTAssertEqual(classifier.classes.count, 1)
                classifierID = classifier.classifierID
                expectation1.fulfill()
        }
        waitForExpectations()

        guard let newClassifierID = classifierID else {
            XCTFail("Failed to create a new classifier due to free account.")
            return
        }

        defer {
            // allow zip files to propagate through object storage, so that
            // they will be deleted when the service deletes the classifier
            // (otherwise they remain and dramatically slow down the tests)
            sleep(15) // wait 15 seconds

            let expectation = self.expectation(description: "Delete the new classifier.")

            visualRecognition.deleteClassifier(withID: newClassifierID, failure: failWithError) {
                expectation.fulfill()
            }
            waitForExpectations()
        }

        var trained = false
        var tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the new classifier.")
            visualRecognition.getClassifier(withID: newClassifierID, failure: failWithError) {
                classifier in

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
            withID: newClassifierID,
            positiveExamples: [trucks],
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                expectation2.fulfill()
        }
        waitForExpectations()

        trained = false
        tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the updated classifier.")
            visualRecognition.getClassifier(withID: newClassifierID, failure: failWithError) {
                classifier in

                if classifier.status == "ready" {
                    XCTAssertEqual(classifier.classes.count, 2)
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
        let cars = PositiveExample(name: "car", examples: examplesCars)
        let classes = [cars]

        var classifierID: String?
        visualRecognition.createClassifier(
            withName: name,
            positiveExamples: classes,
            negativeExamples: examplesTrucks,
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                XCTAssertEqual(classifier.classes.count, 1)
                classifierID = classifier.classifierID
                expectation1.fulfill()
        }
        waitForExpectations()

        guard let newClassifierID = classifierID else {
            XCTFail("Failed to create a new classifier due to free account.")
            return
        }

        defer {
            // allow zip files to propagate through object storage, so that
            // they will be deleted when the service deletes the classifier
            // (otherwise they remain and dramatically slow down the tests)
            sleep(15) // wait 15 seconds

            let expectation = self.expectation(description: "Delete the new classifier.")

            visualRecognition.deleteClassifier(withID: newClassifierID, failure: failWithError) {
                expectation.fulfill()
            }
            waitForExpectations()
        }

        var trained = false
        var tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the new classifier.")
            visualRecognition.getClassifier(withID: newClassifierID, failure: failWithError) {
                classifier in

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
            withID: newClassifierID,
            negativeExamples: examplesBaseball,
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                expectation2.fulfill()
        }
        waitForExpectations()

        trained = false
        tries = 0
        while !trained {
            sleep(15)

            let expectation = self.expectation(description: "Get the updated classifier.")
            visualRecognition.getClassifier(withID: newClassifierID, failure: failWithError) {
                classifier in

                if classifier.status == "ready" {
                    XCTAssertEqual(classifier.classes.count, 1)
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

    /** Classify an image by URL using the default classifier and all default parameters. */
    func testClassifyByURL1() {
        let expectation = self.expectation(description: "Classify an image by URL")

        visualRecognition.classify(image: obamaURL, failure: failWithError) {
            classifiedImages in

            var containsPersonClass = false
            var classifierScore: Double?

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.obamaURL)
            XCTAssertEqual(image?.resolvedURL, self.obamaURL)
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
            for c in classes where c.classification == "person" {
                containsPersonClass = true
                classifierScore = c.score
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
            image: obamaURL,
            owners: ["IBM"],
            classifierIDs: ["default"],
            threshold: 0.5,
            language: "en",
            failure: failWithError)
        {
            classifiedImages in

            var containsPersonClass = false
            var classifierScore: Double?

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.obamaURL)
            XCTAssertEqual(image?.resolvedURL, self.obamaURL)
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
            for c in classes where c.classification == "person" {
                containsPersonClass = true
                classifierScore = c.score
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
        visualRecognition.classify(image: carURL, classifierIDs: [classifierID!], failure: failWithError) {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.carURL)
            XCTAssertEqual(image?.resolvedURL, self.carURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, self.classifierID!)
            XCTAssertEqual(classifier?.name, self.classifierName)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
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
            image: carURL,
            owners: ["me"],
            classifierIDs: [classifierID!],
            threshold: 0.5,
            language: "en",
            failure: failWithError)
        {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.carURL)
            XCTAssertEqual(image?.resolvedURL, self.carURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)

            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, self.classifierID!)
            XCTAssertEqual(classifier?.name, self.classifierName)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
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
        visualRecognition.classify(image: carURL, classifierIDs: ["default", classifierID!], failure: failWithError) {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)

            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertEqual(image?.sourceURL, self.carURL)
            XCTAssertEqual(image?.resolvedURL, self.carURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)

            // verify 2 classifiers are returned
            guard let classifiers = image?.classifiers else {
                XCTFail("No classifiers found")
                return
            }
            XCTAssertEqual(2, classifiers.count)
            for classifier in classifiers {
                var containsCarClass = false
                var classifierScore: Double?
                // verify the image's default classifier
                if classifier.name == "default" {
                    XCTAssertEqual(classifier.classifierID, "default")
                    XCTAssertEqual(classifier.name, "default")

                    XCTAssertGreaterThan(classifier.classes.count, 0)
                    for c in classifier.classes where c.classification == "car" {
                        containsCarClass = true
                        classifierScore = c.score
                    }
                    XCTAssertEqual(containsCarClass, true)
                    if let score = classifierScore {
                        XCTAssertGreaterThan(score, 0.5)
                    }
                } else {
                    // verify the image's custom classifier
                    XCTAssertEqual(classifier.classifierID, self.classifierID!)
                    XCTAssertEqual(classifier.name, self.classifierName)
                    XCTAssertEqual(classifier.classes.count, 1)
                    XCTAssertEqual(classifier.classes.first?.classification, "car")
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
        visualRecognition.classify(imageFile: car, failure: failWithError) {
            classifiedImages in
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
            for c in classes where c.classification == "car" {
                containsPersonClass = true
                classifierScore = c.score
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
            imageFile: car,
            owners: ["IBM"],
            classifierIDs: ["default"],
            threshold: 0.5,
            language: "en",
            failure: failWithError)
        {
            classifiedImages in

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
            for c in classes where c.classification == "car" {
                containsPersonClass = true
                classifierScore = c.score
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
        visualRecognition.classify(imageFile: car, classifierIDs: [classifierID!], failure: failWithError) {
            classifiedImages in

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
            XCTAssertEqual(classifier?.classifierID, self.classifierID!)
            XCTAssertEqual(classifier?.name, self.classifierName)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
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
            imageFile: car,
            owners: ["me"],
            classifierIDs: [classifierID!],
            threshold: 0.5,
            language: "en",
            failure: failWithError)
        {
            classifiedImages in

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
            XCTAssertEqual(classifier?.classifierID, self.classifierID!)
            XCTAssertEqual(classifier?.name, self.classifierName)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
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
            imageFile: car,
            classifierIDs: ["default", classifierID!],
            failure: failWithError)
        {
            classifiedImages in

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
            XCTAssertEqual(2, classifiers.count)
            for classifier in classifiers {
                // verify the image's default classifier
                if classifier.name == "default" {
                    XCTAssertEqual(classifier.classifierID, "default")
                    XCTAssertEqual(classifier.name, "default")

                    XCTAssertGreaterThan(classifier.classes.count, 0)
                    for c in classifier.classes where c.classification == "car" {
                        containsCarClass = true
                        classifierScore = c.score
                    }
                    XCTAssertEqual(containsCarClass, true)
                    if let score = classifierScore {
                        XCTAssertGreaterThan(score, 0.5)
                    }
                } else {
                    // verify the image's custom classifier
                    XCTAssertEqual(classifier.classifierID, self.classifierID!)
                    XCTAssertEqual(classifier.name, self.classifierName)
                    XCTAssertEqual(classifier.classes.count, 1)
                    XCTAssertEqual(classifier.classes.first?.classification, "car")
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
            imageFile: carz,
            classifierIDs: ["default", classifierID!],
            failure: failWithError)
        {
            classifiedImages in

            // verify classified images object
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 4)

            for image in classifiedImages.images {
                // verify the image's metadata
                XCTAssertNil(image.sourceURL)
                XCTAssertNil(image.resolvedURL)
                XCTAssert(image.image?.hasPrefix("car") == true)
                XCTAssertNil(image.error)
                XCTAssertEqual(image.classifiers.count, 2)

                for classifier in image.classifiers {
                    var containsCarClass = false
                    var classifierScore: Double?
                    if classifier.name == "default" {
                        // verify the image's default classifier
                        XCTAssertEqual(classifier.classifierID, "default")
                        XCTAssertEqual(classifier.name, "default")
                        XCTAssertGreaterThan(classifier.classes.count, 0)
                        for c in classifier.classes {
                            let classes = ["car", "vehicle", "sedan", "Parking Garage (Indoor)"]
                            if classes.contains(c.classification) {
                                containsCarClass = true
                                classifierScore = c.score
                            }
                        }
                        XCTAssertEqual(containsCarClass, true)
                        if let score = classifierScore {
                            XCTAssertGreaterThan(score, 0.5)
                        }
                    } else {
                        // verify the image's custom classifier
                        XCTAssertEqual(classifier.classifierID, self.classifierID!)
                        XCTAssertEqual(classifier.name, self.classifierName)
                        XCTAssertEqual(classifier.classes.count, 1)
                        XCTAssertEqual(classifier.classes.first?.classification, "car")
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

    /** Detect faces by URL. */
    func testDetectFacesByURL() {
        let expectation = self.expectation(description: "Detect faces by URL.")
        visualRecognition.detectFaces(inImage: obamaURL, failure: failWithError) {
            faceImages in

            // verify face images object
            XCTAssertEqual(faceImages.imagesProcessed, 1)
            XCTAssertNil(faceImages.warnings)
            XCTAssertEqual(faceImages.images.count, 1)

            // verify the face image object
            let face = faceImages.images.first
            XCTAssertEqual(face?.sourceURL, self.obamaURL)
            XCTAssertEqual(face?.resolvedURL, self.obamaURL)
            XCTAssertNil(face?.image)
            XCTAssertNil(face?.error)
            XCTAssertEqual(face?.faces.count, 1)

            // verify the age
            let age = face?.faces.first?.age
            XCTAssertGreaterThanOrEqual(age!.min!, 45)
            XCTAssertLessThanOrEqual(age!.max!, 54)
            XCTAssertGreaterThanOrEqual(age!.score, 0.25)

            // verify the face location
            let location = face?.faces.first?.location
            XCTAssertEqual(location?.height, 229)
            XCTAssertEqual(location?.left, 213)
            XCTAssertEqual(location?.top, 66)
            XCTAssertEqual(location?.width, 189)

            // verify the gender
            let gender = face?.faces.first?.gender
            XCTAssertEqual(gender!.gender, "MALE")
            XCTAssertGreaterThanOrEqual(gender!.score, 0.75)

            // verify the identity
            let identity = face?.faces.first?.identity
            XCTAssertEqual(identity!.name, "Barack Obama")
            XCTAssertGreaterThanOrEqual(identity!.score, 0.75)

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Detect faces in an uploaded image */
    func testDetectFacesByImage1() {
        let expectation = self.expectation(description: "Detect faces in an uploaded image.")
        visualRecognition.detectFaces(inImageFile: obama, failure: failWithError) {
            faceImages in

            // verify face images object
            XCTAssertEqual(faceImages.imagesProcessed, 1)
            XCTAssertNil(faceImages.warnings)
            XCTAssertEqual(faceImages.images.count, 1)

            // verify the face image object
            let face = faceImages.images.first
            XCTAssertNil(face?.sourceURL)
            XCTAssertNil(face?.resolvedURL)
            XCTAssertNotNil(face?.image)
            XCTAssertNil(face?.error)
            XCTAssertEqual(face?.faces.count, 1)

            // verify the age
            let age = face?.faces.first?.age
            XCTAssertGreaterThanOrEqual(age!.min!, 45)
            XCTAssertLessThanOrEqual(age!.max!, 54)
            XCTAssertGreaterThanOrEqual(age!.score, 0.25)

            // verify the face location
            let location = face?.faces.first?.location
            XCTAssertEqual(location?.height, 229)
            XCTAssertEqual(location?.left, 213)
            XCTAssertEqual(location?.top, 66)
            XCTAssertEqual(location?.width, 189)

            // verify the gender
            let gender = face?.faces.first?.gender
            XCTAssertEqual(gender!.gender, "MALE")
            XCTAssertGreaterThanOrEqual(gender!.score, 0.75)

            // verify the identity
            let identity = face?.faces.first?.identity
            XCTAssertEqual(identity!.name, "Barack Obama")
            XCTAssertGreaterThanOrEqual(identity!.score, 0.75)

            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Detect faces in uploaded images. */
    func testDetectFacesByImage2() {
        let expectation = self.expectation(description: "Detect faces in uploaded images.")
        visualRecognition.detectFaces(inImageFile: faces, failure: failWithError) {
            faceImages in

            // verify face images object
            XCTAssertEqual(faceImages.imagesProcessed, 3)
            XCTAssertNil(faceImages.warnings)
            XCTAssertEqual(faceImages.images.count, 3)

            for image in faceImages.images {
                // verify the face image object
                XCTAssertNil(image.sourceURL)
                XCTAssertNil(image.resolvedURL)
                XCTAssert(image.image?.hasPrefix("faces.zip/faces/face") == true)
                XCTAssertNil(image.error)
                XCTAssertEqual(image.faces.count, 1)

                // verify the age
                let age = image.faces.first?.age
                XCTAssert(age!.min! >= 18)
                XCTAssert(age!.max! <= 44)
                XCTAssert(age!.score >= 0.25)

                // verify the face location
                let location = image.faces.first?.location
                XCTAssert(location!.height >= 100)
                XCTAssert(location!.left >= 30)
                XCTAssert(location!.top >= 20)
                XCTAssert(location!.width >= 90)

                // verify the gender
                let gender = image.faces.first?.gender
                XCTAssert(gender!.gender == "MALE")
                XCTAssert(gender!.score >= 0.75)

                // verify the identity
                if let identity = image.faces.first?.identity {
                    XCTAssertEqual(identity.name, "Tiger Woods")
                    XCTAssert(identity.score >= 0.75)
                }
            }

            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    /** Test creating a classifier with a single image for positive examples. */
    func testCreateClassifierWithInvalidPositiveExamples() {
        let expectation = self.expectation(description: "Create classifier with invalid positive example.")
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        let invalidPositiveExample = PositiveExample(name: "obama", examples: obama)

        visualRecognition.createClassifier(
            withName: "invalidClassifier",
            positiveExamples: [invalidPositiveExample],
            failure: failure,
            success: failWithResult)
        waitForExpectations()
    }

    /** Test classifying an invalid URL using the default classifier and parameters. */
    func testClassifyByInvalidURL() {
        let expectation = self.expectation(description: "Classify an image with an invalid URL.")
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        let invalidImageURL = "invalid-image-url"
        visualRecognition.classify(image: invalidImageURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Test detecting faces with an invalid URL using the default classifier and parameters. */
    func testDetectFacesByInvalidURL() {
        let expectation = self.expectation(description: "Classify an image with an invalid type.")
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        let invalidImageURL = "invalid-image-url"
        visualRecognition.detectFaces(inImage: invalidImageURL, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
