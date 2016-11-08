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

import XCTest
import VisualRecognitionV3

class VisualRecognitionTests: XCTestCase {
    
    private var visualRecognition: VisualRecognition!
    private let classifierName = "swift-sdk-unit-test-cars-trucks"
    private var classifierID: String?
    private let timeout: TimeInterval = 10.0
    private let timeoutLong: TimeInterval = 45.0
    
    static var allTests : [(String, (VisualRecognitionTests) -> () throws -> Void)] {
        return [
            ("testGetClassifiers", testGetClassifiers),
            ("testCreateDeleteClassifier1", testCreateDeleteClassifier1),
            ("testCreateDeleteClassifier2", testCreateDeleteClassifier2),
            ("testGetClassifier", testGetClassifier),
            ("testUpdateClassifier", testUpdateClassifier),
            ("testUpdateClassifierWithPositiveExample", testUpdateClassifierWithPositiveExample),
            ("testUpdateClassifierWithNegativeExample", testUpdateClassifierWithNegativeExample),
            ("testClassifyByURL1", testClassifyByURL1),
            ("testClassifyByURL2", testClassifyByURL2),
            ("testClassifyByURL3", testClassifyByURL3),
            ("testClassifyByURL4", testClassifyByURL4),
            ("testClassifyByURL5", testClassifyByURL5),
//            ("testClassifyImage1", testClassifyImage1), // TODO: add these tests back after fixing upload bug
//            ("testClassifyImage2", testClassifyImage2),
//            ("testClassifyImage3", testClassifyImage3),
//            ("testClassifyImage4", testClassifyImage4),
//            ("testClassifyImage5", testClassifyImage5),
//            ("testClassifyImage6", testClassifyImage6),
            ("testDetectFacesByURL", testDetectFacesByURL),
//            ("testDetectFacesByImage1", testDetectFacesByImage1),
//            ("testDetectFacesByImage2", testDetectFacesByImage2),
        ]
    }
    
    private var examplesBaseball: URL!
    private var examplesCars: URL!
    private var examplesTrucks: URL!
    private var faces: URL!
    private var car: URL!
    private var obama: URL!
    private var sign: URL!
    
    private let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
                           "Administration/People/president_official_portrait_lores.jpg"
    private let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/" +
                         "java-sdk/master/tests/src/test/resources/visual_recognition/car.png"
    private let signURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk/" +
                          "master/src/test/resources/visual_recognition/open.png"
    
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
    }
    
    /** Load image files with class examples and test images. */
    func loadImageFiles() {
        let bundle = Bundle(for: type(of: self))
        guard
            let examplesBaseball = bundle.url(forResource: "baseball", withExtension: "zip"),
            let examplesCars = bundle.url(forResource: "cars", withExtension: "zip"),
            let examplesTrucks = bundle.url(forResource: "trucks", withExtension: "zip"),
            let faces = bundle.url(forResource: "faces", withExtension: "zip"),
            let car = bundle.url(forResource: "car", withExtension: "png"),
            let obama = bundle.url(forResource: "obama", withExtension: "jpg"),
            let sign = bundle.url(forResource: "sign", withExtension: "jpg")
        else {
            XCTFail("Unable to locate sample image files.")
            return
        }
        
        self.examplesBaseball = examplesBaseball
        self.examplesCars = examplesCars
        self.examplesTrucks = examplesTrucks
        self.faces = faces
        self.car = car
        self.obama = obama
        self.sign = sign
    }
    
    /** Look up (or create) the trained classifier. */
    func lookupClassifier() {
        let description = "Look up (or create) the trained classifier."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            XCTFail("Failed to locate the trained classifier.")
        }
        
        visualRecognition.getClassifiers(failure: failure) { classifiers in
            for classifier in classifiers {
                if classifier.name == self.classifierName {
                    XCTAssert(classifier.status == "ready", "Wait for training to complete.")
                    self.classifierID = classifier.classifierID
                    expectation.fulfill()
                    return
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
        
        if (classifierID == nil) {
            trainClassifier()
        }
    }
    
    /** Train a classifier for the test suite. */
    func trainClassifier() {
        let description = "Train a classifier for the test suite."
        let expectation = self.expectation(description: description)
        
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

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    /** Retrieve a list of user-trained classifiers. */
    func testGetClassifiers() {
        let description = "Retrieve a list of user-trained classifiers."
        let expectation = self.expectation(description: description)
        
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
        let description1 = "Train a classifier with only positive examples."
        let expectation1 = expectation(description: description1)
        
        let name = "swift-sdk-unit-test-1"
        let baseball = PositiveExample(name: "baseball", examples: examplesBaseball)
        let cars = PositiveExample(name: "car", examples: examplesCars)
        let trucks = PositiveExample(name: "truck", examples: examplesTrucks)
        let classes = [baseball, cars, trucks]
        
        var classifierID: String?
        visualRecognition.createClassifier(withName: name, positiveExamples: classes, failure: failWithError) {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 3)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Check that our classifier can be retrieved."
        let expectation2 = expectation(description: description2)
        
        visualRecognition.getClassifiers(failure: failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == classifierID! {
                    expectation2.fulfill()
                    return
                }
            }
            XCTFail("The created classifier could not be retrieved from the service.")
        }
        waitForExpectations()
        
        let description3 = "Delete the custom classifier."
        let expectation3 = expectation(description: description3)
        
        visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    /** Train a classifier with both positive and negative examples. */
    func testCreateDeleteClassifier2() {
        let description1 = "Train a classifier with both positive and negative examples."
        let expectation1 = expectation(description: description1)
        
        let name = "swift-sdk-unit-test-2"
        let cars = PositiveExample(name: "car", examples: examplesCars)
        
        var classifierID: String?
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
        
        let description2 = "Check that our classifier can be retrieved."
        let expectation2 = expectation(description: description2)
        
        visualRecognition.getClassifiers(failure: failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == classifierID! {
                    expectation2.fulfill()
                    return
                }
            }
            XCTFail("The created classifier could not be retrieved from the service.")
        }
        waitForExpectations()
        
        let description3 = "Delete the custom classifier."
        let expectation3 = expectation(description: description3)

        visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get information about the trained classifier. */
    func testGetClassifier() {
        let description = "Get information about the trained classifier."
        let expectation = self.expectation(description: description)

        visualRecognition.getClassifier(withID: classifierID!, failure: failWithError) {
            classifier in
            XCTAssertEqual(classifier.name, self.classifierName)
            XCTAssertEqual(classifier.classes.count, 1)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Update the trained classifier. */
    func testUpdateClassifier() {
        let description = "Update the trained classifier."
        let expectation = self.expectation(description: description)
        
        let car = PositiveExample(name: "car", examples: examplesCars)
        visualRecognition.updateClassifier(
            withID: classifierID!,
            positiveExamples: [car],
            negativeExamples: examplesTrucks,
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, self.classifierName)
                expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Update the classifier with a positive example. */
    func testUpdateClassifierWithPositiveExample() {
        let description1 = "Train a new classifier with positive examples."
        let expectation1 = expectation(description: description1)
        
        let name = "swift-sdk-unit-test-positive-update"
        let cars = PositiveExample(name: "car", examples: examplesCars)
        let trucks = PositiveExample(name: "truck", examples: examplesTrucks)
        
        var classifierID: String?
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
        
        var trained = false
        var tries = 0
        while(!trained) {
            tries += 1
            let description = "Get the new classifier."
            let expectation = self.expectation(description: description)
            visualRecognition.getClassifier(withID: classifierID!, failure: failWithError) {
                classifier in
                
                if classifier.status == "ready" {
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()
            
            if tries > 5 {
                let description = "Delete the new classifier."
                let expectation = self.expectation(description: description)
                
                visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
                    expectation.fulfill()
                }
                waitForExpectations()
                
                XCTFail("Could not train a new classifier. Try again later.")
            }
            
            sleep(5)
        }
        
        let description2 = "Update the classifier with a positive example."
        let expectation2 = expectation(description: description2)
        
        visualRecognition.updateClassifier(
            withID: classifierID!,
            positiveExamples: [trucks],
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                expectation2.fulfill()
        }
        waitForExpectations()
        
        trained = false
        tries = 0
        while(!trained) {
            tries += 1
            let description = "Get the updated classifier and make sure there are 2 classes."
            let expectation = self.expectation(description: description)
            visualRecognition.getClassifier(withID: classifierID!, failure: failWithError) {
                classifier in
                
                if classifier.status == "ready" {
                    XCTAssertEqual(classifier.classes.count, 2)
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()
            
            if tries > 5 {
                let description = "Delete the new classifier."
                let expectation = self.expectation(description: description)
                
                visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
                    expectation.fulfill()
                }
                waitForExpectations()
                
                XCTFail("Could not update the classifier. Try again later.")
            }
            
            sleep(5)
        }
        
        let description4 = "Delete the custom classifier."
        let expectation4 = expectation(description: description4)
        
        visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Update the classifier with a negative example. */
    func testUpdateClassifierWithNegativeExample() {
        let description1 = "Train a new classifier with positive examples."
        let expectation1 = expectation(description: description1)
        
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
        
        var trained = false
        var tries = 0
        while(!trained) {
            tries += 1
            let description = "Get the new classifier."
            let expectation = self.expectation(description: description)
            visualRecognition.getClassifier(withID: classifierID!, failure: failWithError) {
                classifier in
                
                if classifier.status == "ready" {
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()
            
            if tries > 5 {
                let description = "Delete the new classifier."
                let expectation = self.expectation(description: description)
                
                visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
                    expectation.fulfill()
                }
                waitForExpectations()
                
                XCTFail("Could not train a new classifier. Try again later.")
            }
            
            sleep(5)
        }
        
        let description2 = "Update the classifier with a negative example."
        let expectation2 = expectation(description: description2)
        visualRecognition.updateClassifier(
            withID: classifierID!,
            negativeExamples: examplesBaseball,
            failure: failWithError) { classifier in
                XCTAssertEqual(classifier.name, name)
                expectation2.fulfill()
        }
        waitForExpectations()
        
        trained = false
        tries = 0
        while(!trained) {
            tries += 1
            let description = "Get the updated classifier and make sure there is 1 class."
            let expectation = self.expectation(description: description)
            visualRecognition.getClassifier(withID: classifierID!, failure: failWithError) {
                classifier in
                
                if classifier.status == "ready" {
                    XCTAssertEqual(classifier.classes.count, 1)
                    trained = true
                }
                expectation.fulfill()
            }
            waitForExpectations()
            
            if tries > 5 {
                let description = "Delete the new classifier."
                let expectation = self.expectation(description: description)
                
                visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
                    expectation.fulfill()
                }
                waitForExpectations()
                
                XCTFail("Could not update the classifier. Try again later.")
            }
            
            sleep(5)
        }
        
        let description4 = "Delete the custom classifier."
        let expectation4 = expectation(description: description4)
        
        visualRecognition.deleteClassifier(withID: classifierID!, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify an image by URL using the default classifier and all default parameters. */
    func testClassifyByURL1() {
        let description = "Classify an image by URL using the default classifier."
        let expectation = self.expectation(description: description)
        
        visualRecognition.classify(image: obamaURL, failure: failWithError) {
            classifiedImages in
            
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
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "person")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify an image by URL using the default classifier and specifying default parameters. */
    func testClassifyByURL2() {
        let description = "Classify an image by URL using the default classifier."
        let expectation = self.expectation(description: description)
        
        visualRecognition.classify(
            image: obamaURL,
            owners: ["IBM"],
            classifierIDs: ["default"],
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
            XCTAssertEqual(image?.sourceURL, self.obamaURL)
            XCTAssertEqual(image?.resolvedURL, self.obamaURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.classifiers.count, 1)
            
            // verify the image's classifier
            let classifier = image?.classifiers.first
            XCTAssertEqual(classifier?.classifierID, "default")
            XCTAssertEqual(classifier?.name, "default")
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "person")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify an image by URL using a custom classifier and all default parameters. */
    func testClassifyByURL3() {
        let description = "Classify an image by URL using a custom classifier."
        let expectation = self.expectation(description: description)
        
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
        let description = "Classify an image by URL using a custom classifier."
        let expectation = self.expectation(description: description)
        
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
        let description = "Classify an image by URL using a custom classifier."
        let expectation = self.expectation(description: description)
        
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
            XCTAssertEqual(image?.classifiers.count, 2)
            
            // verify the image's default classifier
            let classifier1 = image?.classifiers.first
            XCTAssertEqual(classifier1?.classifierID, "default")
            XCTAssertEqual(classifier1?.name, "default")
            XCTAssertEqual(classifier1?.classes.count, 4)
            XCTAssertEqual(classifier1?.classes.first?.classification, "car")
            if let score = classifier1?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            // verify the image's custom classifier
            let classifier2 = image?.classifiers.last
            XCTAssertEqual(classifier2?.classifierID, self.classifierID!)
            XCTAssertEqual(classifier2?.name, self.classifierName)
            XCTAssertEqual(classifier2?.classes.count, 1)
            XCTAssertEqual(classifier2?.classes.first?.classification, "car")
            if let score = classifier2?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
//     TODO: Add these tests back when we have updated the classify function.
//    
//    /** Classify an uploaded image using the default classifier and all default parameters. */
//    func testClassifyImage1() {
//        let description = "Classify an uploaded image using the default classifier."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.classify(imageFile: car, failure: failWithError) {
//            classifiedImages in
//            
//            // verify classified images object
//            XCTAssertNil(classifiedImages.warnings)
//            XCTAssertEqual(classifiedImages.images.count, 1)
//            
//            // verify the image's metadata
//            let image = classifiedImages.images.first
//            XCTAssertNil(image?.sourceURL)
//            XCTAssertNil(image?.resolvedURL)
//            XCTAssert(image?.image == "car.png")
//            XCTAssertNil(image?.error)
//            XCTAssertEqual(image?.classifiers.count, 1)
//            
//            // verify the image's classifier
//            let classifier = image?.classifiers.first
//            XCTAssertEqual(classifier?.classifierID, "default")
//            XCTAssertEqual(classifier?.name, "default")
//            XCTAssertEqual(classifier?.classes.count, 4)
//            XCTAssertEqual(classifier?.classes.first?.classification, "car")
//            if let score = classifier?.classes.first?.score {
//                XCTAssertGreaterThan(score, 0.5)
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
//    
//    /** Classify an uploaded image using the default classifier and specifying default parameters. */
//    func testClassifyImage2() {
//        let description = "Classify an uploaded image using the default classifier."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.classify(
//            imageFile: car,
//            owners: ["IBM"],
//            classifierIDs: ["default"],
//            threshold: 0.5,
//            language: "en",
//            failure: failWithError)
//        {
//            classifiedImages in
//            
//            // verify classified images object
//            XCTAssertNil(classifiedImages.warnings)
//            XCTAssertEqual(classifiedImages.images.count, 1)
//            
//            // verify the image's metadata
//            let image = classifiedImages.images.first
//            XCTAssertNil(image?.sourceURL)
//            XCTAssertNil(image?.resolvedURL)
//            XCTAssert(image?.image == "car.png")
//            XCTAssertNil(image?.error)
//            XCTAssertEqual(image?.classifiers.count, 1)
//            
//            // verify the image's classifier
//            let classifier = image?.classifiers.first
//            XCTAssertEqual(classifier?.classifierID, "default")
//            XCTAssertEqual(classifier?.name, "default")
//            XCTAssertEqual(classifier?.classes.count, 4)
//            XCTAssertEqual(classifier?.classes.first?.classification, "car")
//            if let score = classifier?.classes.first?.score {
//                XCTAssertGreaterThan(score, 0.5)
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
//    
//    /** Classify an uploaded image using a custom classifier and all default parameters. */
//    func testClassifyImage3() {
//        let description = "Classify an uploaded image using a custom classifier."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.classify(imageFile: car, classifierIDs: [classifierID!], failure: failWithError) {
//            classifiedImages in
//            
//            // verify classified images object
//            XCTAssertNil(classifiedImages.warnings)
//            XCTAssertEqual(classifiedImages.images.count, 1)
//            
//            // verify the image's metadata
//            let image = classifiedImages.images.first
//            XCTAssertNil(image?.sourceURL)
//            XCTAssertNil(image?.resolvedURL)
//            XCTAssert(image?.image == "car.png")
//            XCTAssertNil(image?.error)
//            XCTAssertEqual(image?.classifiers.count, 1)
//            
//            // verify the image's classifier
//            let classifier = image?.classifiers.first
//            XCTAssertEqual(classifier?.classifierID, self.classifierID!)
//            XCTAssertEqual(classifier?.name, self.classifierName)
//            XCTAssertEqual(classifier?.classes.count, 1)
//            XCTAssertEqual(classifier?.classes.first?.classification, "car")
//            if let score = classifier?.classes.first?.score {
//                XCTAssertGreaterThan(score, 0.5)
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
//    
//    /** Classify an uploaded image using a custom classifier and specifying default parameters. */
//    func testClassifyImage4() {
//        let description = "Classify an uploaded image using a custom classifier."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.classify(
//            imageFile: car,
//            owners: ["me"],
//            classifierIDs: [classifierID!],
//            threshold: 0.5,
//            language: "en",
//            failure: failWithError)
//        {
//            classifiedImages in
//            
//            // verify classified images object
//            XCTAssertNil(classifiedImages.warnings)
//            XCTAssertEqual(classifiedImages.images.count, 1)
//            
//            // verify the image's metadata
//            let image = classifiedImages.images.first
//            XCTAssertNil(image?.sourceURL)
//            XCTAssertNil(image?.resolvedURL)
//            XCTAssert(image?.image == "car.png")
//            XCTAssertNil(image?.error)
//            XCTAssertEqual(image?.classifiers.count, 1)
//            
//            // verify the image's classifier
//            let classifier = image?.classifiers.first
//            XCTAssertEqual(classifier?.classifierID, self.classifierID!)
//            XCTAssertEqual(classifier?.name, self.classifierName)
//            XCTAssertEqual(classifier?.classes.count, 1)
//            XCTAssertEqual(classifier?.classes.first?.classification, "car")
//            if let score = classifier?.classes.first?.score {
//                XCTAssertGreaterThan(score, 0.5)
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
//    
//    /** Classify an uploaded image with both the default classifier and a custom classifier. */
//    func testClassifyImage5() {
//        let description = "Classify an uploaded image with the default and custom classifiers."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.classify(
//            imageFile: car,
//            classifierIDs: ["default", classifierID!],
//            failure: failWithError)
//        {
//            classifiedImages in
//            
//            // verify classified images object
//            XCTAssertNil(classifiedImages.warnings)
//            XCTAssertEqual(classifiedImages.images.count, 1)
//            
//            // verify the image's metadata
//            let image = classifiedImages.images.first
//            XCTAssertNil(image?.sourceURL)
//            XCTAssertNil(image?.resolvedURL)
//            XCTAssert(image?.image == "car.png")
//            XCTAssertNil(image?.error)
//            XCTAssertEqual(image?.classifiers.count, 2)
//            
//            // verify the image's default classifier
//            let classifier1 = image?.classifiers.first
//            XCTAssertEqual(classifier1?.classifierID, "default")
//            XCTAssertEqual(classifier1?.name, "default")
//            XCTAssertEqual(classifier1?.classes.count, 4)
//            XCTAssertEqual(classifier1?.classes.first?.classification, "car")
//            if let score = classifier1?.classes.first?.score {
//                XCTAssertGreaterThan(score, 0.5)
//            }
//            
//            // verify the image's custom classifier
//            let classifier2 = image?.classifiers.last
//            XCTAssertEqual(classifier2?.classifierID, self.classifierID!)
//            XCTAssertEqual(classifier2?.name, self.classifierName)
//            XCTAssertEqual(classifier2?.classes.count, 1)
//            XCTAssertEqual(classifier2?.classes.first?.classification, "car")
//            if let score = classifier2?.classes.first?.score {
//                XCTAssertGreaterThan(score, 0.5)
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
//    
//    /** Classify multiple images using a custom classifier. */
//    func testClassifyImage6() {
//        let description = "Classify multiple images using a custom classifier."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.classify(
//            imageFile: examplesCars,
//            classifierIDs: ["default", classifierID!],
//            failure: failWithError)
//        {
//            classifiedImages in
//            
//            // verify classified images object
//            XCTAssertNil(classifiedImages.warnings)
//            XCTAssertEqual(classifiedImages.images.count, 16)
//            
//            for image in classifiedImages.images {
//                // verify the image's metadata
//                XCTAssertNil(image.sourceURL)
//                XCTAssertNil(image.resolvedURL)
//                XCTAssert(image.image?.hasPrefix("car") == true)
//                XCTAssertNil(image.error)
//                XCTAssertEqual(image.classifiers.count, 2)
//            
//                // verify the image's default classifier
//                let classifier1 = image.classifiers.first
//                XCTAssertEqual(classifier1?.classifierID, "default")
//                XCTAssertEqual(classifier1?.name, "default")
//                XCTAssert(classifier1!.classes.count >= 1)
//                let classification = classifier1?.classes.first?.classification
//                XCTAssert(classification == "car" || classification == "vehicle")
//                if let score = classifier1?.classes.first?.score {
//                    XCTAssertGreaterThan(score, 0.5)
//                }
//                
//                // verify the image's custom classifier
//                let classifier2 = image.classifiers.last
//                XCTAssertEqual(classifier2?.classifierID, self.classifierID!)
//                XCTAssertEqual(classifier2?.name, self.classifierName)
//                XCTAssertEqual(classifier2?.classes.count, 1)
//                XCTAssertEqual(classifier2?.classes.first?.classification, "car")
//                if let score = classifier2?.classes.first?.score {
//                    XCTAssertGreaterThan(score, 0.5)
//                }
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
    
    /** Detect faces by URL. */
    func testDetectFacesByURL() {
        let description = "Detect faces by URL."
        let expectation = self.expectation(description: description)
        
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
            XCTAssertGreaterThanOrEqual(age!.min, 45)
            XCTAssertLessThanOrEqual(age!.max, 54)
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
    
//    TODO: Add these tests back when the detectFaces function has been updated.
//
//    /** Detect faces in an uploaded image */
//    func testDetectFacesByImage1() {
//        let description = "Detect faces in an uploaded image."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.detectFaces(inImageFile: obama, failure: failWithError) {
//            faceImages in
//            
//            // verify face images object
//            XCTAssertEqual(faceImages.imagesProcessed, 1)
//            XCTAssertNil(faceImages.warnings)
//            XCTAssertEqual(faceImages.images.count, 1)
//            
//            // verify the face image object
//            let face = faceImages.images.first
//            XCTAssertEqual(face?.sourceURL, self.obamaURL)
//            XCTAssertEqual(face?.resolvedURL, self.obamaURL)
//            XCTAssertNil(face?.image)
//            XCTAssertNil(face?.error)
//            XCTAssertEqual(face?.faces.count, 1)
//            
//            // verify the age
//            let age = face?.faces.first?.age
//            XCTAssertGreaterThanOrEqual(age!.min, 45)
//            XCTAssertLessThanOrEqual(age!.max, 54)
//            XCTAssertGreaterThanOrEqual(age!.score, 0.25)
//            
//            // verify the face location
//            let location = face?.faces.first?.location
//            XCTAssertEqual(location?.height, 229)
//            XCTAssertEqual(location?.left, 213)
//            XCTAssertEqual(location?.top, 66)
//            XCTAssertEqual(location?.width, 189)
//            
//            // verify the gender
//            let gender = face?.faces.first?.gender
//            XCTAssertEqual(gender!.gender, "MALE")
//            XCTAssertGreaterThanOrEqual(gender!.score, 0.75)
//            
//            // verify the identity
//            let identity = face?.faces.first?.identity
//            XCTAssertEqual(identity!.name, "Barack Obama")
//            XCTAssertGreaterThanOrEqual(identity!.score, 0.75)
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
//    
//    /** Detect faces in uploaded images. */
//    func testDetectFacesByImage2() {
//        let description = "Detect faces in uploaded images."
//        let expectation = self.expectation(description: description)
//        
//        visualRecognition.detectFaces(inImageFile: faces, failure: failWithError) {
//            faceImages in
//            
//            // verify face images object
//            XCTAssertEqual(faceImages.imagesProcessed, 3)
//            XCTAssertNil(faceImages.warnings)
//            XCTAssertEqual(faceImages.images.count, 3)
//            
//            for image in faceImages.images {
//                // verify the face image object
//                XCTAssertNil(image.sourceURL)
//                XCTAssertNil(image.resolvedURL)
//                XCTAssert(image.image?.hasPrefix("faces.zip/faces/face") == true)
//                XCTAssertNil(image.error)
//                XCTAssertEqual(image.faces.count, 1)
//                
//                // verify the age
//                let age = image.faces.first?.age
//                XCTAssert(age!.min >= 18)
//                XCTAssert(age!.max <= 44)
//                XCTAssert(age!.score >= 0.25)
//                
//                // verify the face location
//                let location = image.faces.first?.location
//                XCTAssert(location!.height >= 100)
//                XCTAssert(location!.left >= 30)
//                XCTAssert(location!.top >= 20)
//                XCTAssert(location!.width >= 90)
//                
//                // verify the gender
//                let gender = image.faces.first?.gender
//                XCTAssert(gender!.gender == "MALE")
//                XCTAssert(gender!.score >= 0.75)
//                
//                // verify the identity
//                if let identity = image.faces.first?.identity {
//                    XCTAssertEqual(identity.name, "Tiger Woods")
//                    XCTAssert(identity.score >= 0.75)
//                }
//            }
//            
//            expectation.fulfill()
//        }
//        waitForExpectations()
//    }
}
