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
    private let classifierPrefix = "swift-sdk-unit-test-"
    private let timeout: NSTimeInterval = 60.0
    
    private var examplesBaseball: NSURL!
    private var examplesCars: NSURL!
    private var examplesTrucks: NSURL!
    private var faces: NSURL!
    private var car: NSURL!
    private var obama: NSURL!
    private var sign: NSURL!
    
    private let obamaURL = "https://www.whitehouse.gov/sites/whitehouse.gov/files/images/" +
                           "Administration/People/president_official_portrait_lores.jpg"
    private let carURL = "https://raw.githubusercontent.com/watson-developer-cloud/" +
                         "java-sdk/master/src/test/resources/visual_recognition/car.png"
    private let signURL = "https://raw.githubusercontent.com/watson-developer-cloud/java-sdk/" +
                          "master/src/test/resources/visual_recognition/open.png"
    
    // MARK: - Test Configuration
    
    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateVisualRecognition()
        loadImageFiles()
        deleteStaleClassifiers()
    }
    
    /** Instantiate Visual Recognition. */
    func instantiateVisualRecognition() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let apiKey = credentials["VisualRecognitionAPIKey"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        visualRecognition = VisualRecognition(apiKey: apiKey, version: "2016-05-10")
    }
    
    /** Load image files with class examples and test images. */
    func loadImageFiles() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let examplesBaseball = bundle.URLForResource("baseball", withExtension: "zip"),
            let examplesCars = bundle.URLForResource("cars", withExtension: "zip"),
            let examplesTrucks = bundle.URLForResource("trucks", withExtension: "zip"),
            let faces = bundle.URLForResource("faces", withExtension: "zip"),
            let car = bundle.URLForResource("car", withExtension: "png"),
            let obama = bundle.URLForResource("obama", withExtension: "jpg"),
            let sign = bundle.URLForResource("sign", withExtension: "jpg")
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
    
    /** Delete any stale classifiers previously created by our unit tests. */
    func deleteStaleClassifiers() {
        let description = "Delete any stale classifiers previously created by our unit tests."
        let expectation = expectationWithDescription(description)
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.name.hasPrefix(self.classifierPrefix) {
                    self.visualRecognition.deleteClassifier(classifier.classifierID)
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    /** Retrieve a list of user-trained classifiers. */
    func testGetClassifiers() {
        let description = "Retrieve a list of user-trained classifiers."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Train a classifier with only positive examples. */
    func testCreateDeleteClassifier1() {
        let description1 = "Train a classifier with only positive examples."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "baseball-cars-trucks"
        let baseball = Class(name: "baseball", examples: examplesBaseball)
        let cars = Class(name: "car", examples: examplesCars)
        let trucks = Class(name: "truck", examples: examplesTrucks)
        let classes = [baseball, cars, trucks]
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: classes,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 3)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Check that our classifier can be retrieved."
        let expectation2 = expectationWithDescription(description2)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    expectation2.fulfill()
                    return
                }
            }
            XCTFail("The created classifier could not be retrieved from the service.")
        }
        waitForExpectations()
        
        let description3 = "Delete the custom classifier."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.deleteClassifier(id, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    /** Train a classifier with both positive and negative examples. */
    func testCreateDeleteClassifier2() {
        let description1 = "Train a classifier with both positive and negative examples."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Check that our classifier can be retrieved."
        let expectation2 = expectationWithDescription(description2)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    expectation2.fulfill()
                    return
                }
            }
            XCTFail("The created classifier could not be retrieved from the service.")
        }
        waitForExpectations()
        
        let description3 = "Delete the custom classifier."
        let expectation3 = expectationWithDescription(description3)

        visualRecognition.deleteClassifier(id, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get information about a classifier. */
    func testGetClassifier() {
        let description1 = "Train a classifier with both positive and negative examples."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }

        let description2 = "Get information about the custom classifier."
        let expectation2 = expectationWithDescription(description2)

        visualRecognition.getClassifier(id, failure: failWithError) {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete the custom classifier."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.deleteClassifier(id, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify images by URL using the default classifier and all default parameters. */
    func testClassifyByURL1() {
        let description = "Classify images by URL using the default classifier."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.classify(obamaURL, failure: failWithError) {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 1)
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
    
    /** Classify images by URL using the default classifier and specifying default parameters. */
    func testClassifyByURL2() {
        let description = "Classify images by URL using the default classifier."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.classify(
            obamaURL,
            owners: ["IBM"],
            classifierIDs: ["default"],
            showLowConfidence: true,
            outputLanguage: "en",
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 1)
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
    
    /** Classify images by URL using a custom classifier and all default parameters. */
    func testClassifyByURL3() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 10.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()

        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        
        visualRecognition.classify(carURL, classifierIDs: [id], failure: failWithError) {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 0) // Should be 1? Bug with service?
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
            XCTAssertEqual(classifier?.classifierID, id)
            XCTAssertEqual(classifier?.name, name)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify images by URL using a custom classifier and specifying default parameters. */
    func testClassifyByURL4() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 10.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()
        
        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        
        visualRecognition.classify(
            carURL,
            owners: ["me"],
            classifierIDs: [id],
            showLowConfidence: true,
            outputLanguage: "en",
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 0) // Should be 1? Bug with service?
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
            XCTAssertEqual(classifier?.classifierID, id)
            XCTAssertEqual(classifier?.name, name)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify images by URL with both the default classifier and a custom classifier. */
    func testClassifyByURL5() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 10.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()
        
        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        
        visualRecognition.classify(
            carURL,
            classifierIDs: ["default", id],
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 1)
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
            XCTAssertEqual(classifier2?.classifierID, id)
            XCTAssertEqual(classifier2?.name, name)
            XCTAssertEqual(classifier2?.classes.count, 1)
            XCTAssertEqual(classifier2?.classes.first?.classification, "car")
            if let score = classifier2?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify uploaded images using the default classifier and all default parameters. */
    func testClassifyImage1() {
        let description = "Classify uploaded images using the default classifier."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.classify(car, failure: failWithError) {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 1)
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
            XCTAssertEqual(classifier?.classes.count, 4)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify uploaded images using the default classifier and specifying default parameters. */
    func testClassifyImage2() {
        let description = "Classify uploaded images using the default classifier."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.classify(
            car,
            owners: ["IBM"],
            classifierIDs: ["default"],
            showLowConfidence: true,
            outputLanguage: "en",
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 1)
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
            XCTAssertEqual(classifier?.classes.count, 4)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify uploaded images using a custom classifier and all default parameters. */
    func testClassifyImage3() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 10.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()
        
        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        
        visualRecognition.classify(car, classifierIDs: [id], failure: failWithError) {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 0) // Should be 1? Bug with service?
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
            XCTAssertEqual(classifier?.classifierID, id)
            XCTAssertEqual(classifier?.name, name)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify uploaded images using a custom classifier and specifying default parameters. */
    func testClassifyImage4() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 10.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()
        
        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        
        visualRecognition.classify(
            car,
            owners: ["me"],
            classifierIDs: [id],
            showLowConfidence: true,
            outputLanguage: "en",
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 0) // Should be 1? Bug with service?
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
            XCTAssertEqual(classifier?.classifierID, id)
            XCTAssertEqual(classifier?.name, name)
            XCTAssertEqual(classifier?.classes.count, 1)
            XCTAssertEqual(classifier?.classes.first?.classification, "car")
            if let score = classifier?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify uploaded images with both the default classifier and a custom classifier. */
    func testClassifyImage5() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 10.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()
        
        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        
        visualRecognition.classify(
            car,
            classifierIDs: ["default", id],
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 1)
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 1)
            
            // verify the image's metadata
            let image = classifiedImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssert(image?.image == "car.png")
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
            XCTAssertEqual(classifier2?.classifierID, id)
            XCTAssertEqual(classifier2?.name, name)
            XCTAssertEqual(classifier2?.classes.count, 1)
            XCTAssertEqual(classifier2?.classes.first?.classification, "car")
            if let score = classifier2?.classes.first?.score {
                XCTAssertGreaterThan(score, 0.5)
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Classify multiple images using a custom classifier. */
    func testClassifyImage6() {
        let description1 = "Create a custom classifier."
        let expectation1 = expectationWithDescription(description1)
        
        let name = classifierPrefix + "cars-trucks"
        let cars = Class(name: "car", examples: examplesCars)
        
        var classifierID: String?
        visualRecognition.createClassifier(
            name,
            positiveExamples: [cars],
            negativeExamples: examplesTrucks,
            failure: failWithError)
        {
            classifier in
            XCTAssertEqual(classifier.name, name)
            XCTAssertEqual(classifier.classes.count, 1)
            classifierID = classifier.classifierID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        guard let id = classifierID else {
            XCTFail("Classifier ID should not be nil.")
            return
        }
        
        let description2 = "Wait for the classifier to be trained."
        let expectation2 = expectationWithDescription(description2)
        
        let seconds = 15.0
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Ensure the classifier was trained."
        let expectation3 = expectationWithDescription(description3)
        
        visualRecognition.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if classifier.classifierID == id {
                    XCTAssertEqual(classifier.status, "ready")
                    expectation3.fulfill()
                    return
                }
            }
            XCTFail("The created classifier needs more time to train. Increase the delay.")
        }
        waitForExpectations()
        
        let description4 = "Classify images by URL using a custom classifier."
        let expectation4 = expectationWithDescription(description4)
        visualRecognition.classify(
            examplesCars,
            classifierIDs: ["default", id],
            failure: failWithError)
        {
            classifiedImages in
            
            // verify classified images object
            XCTAssertEqual(classifiedImages.imagesProcessed, 16)
            XCTAssertNil(classifiedImages.warnings)
            XCTAssertEqual(classifiedImages.images.count, 16)
            
            for image in classifiedImages.images {
                // verify the image's metadata
                XCTAssertNil(image.sourceURL)
                XCTAssertNil(image.resolvedURL)
                XCTAssert(image.image?.hasPrefix("car") == true)
                XCTAssertNil(image.error)
                XCTAssertEqual(image.classifiers.count, 2)
            
                // verify the image's default classifier
                let classifier1 = image.classifiers.first
                XCTAssertEqual(classifier1?.classifierID, "default")
                XCTAssertEqual(classifier1?.name, "default")
                XCTAssert(classifier1?.classes.count >= 1)
                let classification = classifier1?.classes.first?.classification
                XCTAssert(classification == "car" || classification == "vehicle")
                if let score = classifier1?.classes.first?.score {
                    XCTAssertGreaterThan(score, 0.5)
                }
                
                // verify the image's custom classifier
                let classifier2 = image.classifiers.last
                XCTAssertEqual(classifier2?.classifierID, id)
                XCTAssertEqual(classifier2?.name, name)
                XCTAssertEqual(classifier2?.classes.count, 1)
                XCTAssertEqual(classifier2?.classes.first?.classification, "car")
                if let score = classifier2?.classes.first?.score {
                    XCTAssertGreaterThan(score, 0.5)
                }
            }
            
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Detect faces by URL. */
    func testDetectFacesByURL() {
        let description = "Detect faces by URL."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.detectFaces(obamaURL, failure: failWithError) {
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
            XCTAssert(age?.min >= 55)
            XCTAssert(age?.max <= 64)
            XCTAssert(age?.score >= 0.25)
            
            // verify the face location
            let location = face?.faces.first?.location
            XCTAssert(location?.height == 185)
            XCTAssert(location?.left == 200)
            XCTAssert(location?.top == 65)
            XCTAssert(location?.width == 175)
            
            // verify the gender
            let gender = face?.faces.first?.gender
            XCTAssert(gender?.gender == "MALE")
            XCTAssert(gender?.score >= 0.75)
            
            // verify the identity
            let identity = face?.faces.first?.identity
            XCTAssert(identity?.name == "Barack Obama")
            XCTAssert(identity?.score >= 0.75)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Detect faces in an uploaded image */
    func testDetectFacesByImage1() {
        let description = "Detect faces in an uploaded image."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.detectFaces(obama, failure: failWithError) {
            faceImages in
            
            // verify face images object
            XCTAssertEqual(faceImages.imagesProcessed, 1)
            XCTAssertNil(faceImages.warnings)
            XCTAssertEqual(faceImages.images.count, 1)
            
            // verify the face image object
            let face = faceImages.images.first
            XCTAssertNil(face?.sourceURL)
            XCTAssertNil(face?.resolvedURL)
            XCTAssertEqual(face?.image, "obama.jpg")
            XCTAssertNil(face?.error)
            XCTAssertEqual(face?.faces.count, 1)
            
            // verify the age
            let age = face?.faces.first?.age
            XCTAssert(age?.min >= 55)
            XCTAssert(age?.max <= 64)
            XCTAssert(age?.score >= 0.25)
            
            // verify the face location
            let location = face?.faces.first?.location
            XCTAssert(location?.height == 185)
            XCTAssert(location?.left == 200)
            XCTAssert(location?.top == 65)
            XCTAssert(location?.width == 175)
            
            // verify the gender
            let gender = face?.faces.first?.gender
            XCTAssert(gender?.gender == "MALE")
            XCTAssert(gender?.score >= 0.75)
            
            // verify the identity
            let identity = face?.faces.first?.identity
            XCTAssert(identity?.name == "Barack Obama")
            XCTAssert(identity?.score >= 0.75)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Detect faces in uploaded images. */
    func testDetectFacesByImage2() {
        let description = "Detect faces in uploaded images."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.detectFaces(faces, failure: failWithError) {
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
                XCTAssert(age?.min >= 18)
                XCTAssert(age?.max <= 44)
                XCTAssert(age?.score >= 0.25)
                
                // verify the face location
                let location = image.faces.first?.location
                XCTAssert(location?.height >= 100)
                XCTAssert(location?.left >= 30)
                XCTAssert(location?.top >= 20)
                XCTAssert(location?.width >= 90)
                
                // verify the gender
                let gender = image.faces.first?.gender
                XCTAssert(gender?.gender == "MALE")
                XCTAssert(gender?.score >= 0.75)
                
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
    
    /** Recognize text by URL. */
    func testRecognizeTextURL() {
        let description = "Recognize text by URL."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.recognizeText(signURL, failure: failWithError) {
            wordImages in
            
            // verify the word images object
            XCTAssertEqual(wordImages.imagesProcessed, 1)
            XCTAssertNil(wordImages.warnings)
            XCTAssertEqual(wordImages.images.count, 1)
            
            // verify the word image object
            let image = wordImages.images.first
            XCTAssertEqual(image?.sourceURL, self.signURL)
            XCTAssertEqual(image?.resolvedURL, self.signURL)
            XCTAssertNil(image?.image)
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.text, "its\nopen")
            
            // verify first word
            let word1 = image?.words.first
            XCTAssertEqual(word1?.lineNumber, 0)
            XCTAssertNotNil(word1?.location)
            XCTAssert(word1?.score >= 0.9)
            XCTAssertEqual(word1?.word, "its")
            
            // verify second word
            let word2 = image?.words.last
            XCTAssertEqual(word2?.lineNumber, 1)
            XCTAssertNotNil(word2?.location)
            XCTAssert(word2?.score >= 0.9)
            XCTAssertEqual(word2?.word, "open")
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Recognize text in an uploaded image. */
    func testRecognizeTextByImage1() {
        let description = "Recognize text in an uploaded image."
        let expectation = expectationWithDescription(description)
        
        visualRecognition.recognizeText(sign, failure: failWithError) {
            wordImages in
            
            // verify the word images object
            XCTAssertEqual(wordImages.imagesProcessed, 1)
            XCTAssertNil(wordImages.warnings)
            XCTAssertEqual(wordImages.images.count, 1)
            
            // verify the word image object
            let image = wordImages.images.first
            XCTAssertNil(image?.sourceURL)
            XCTAssertNil(image?.resolvedURL)
            XCTAssertEqual(image?.image, "sign.jpg")
            XCTAssertNil(image?.error)
            XCTAssertEqual(image?.text, "notice\nincreased\ntrain traffic")
            
            // verify the first word
            let word1 = image?.words[0]
            XCTAssertEqual(word1?.lineNumber, 0)
            XCTAssertNotNil(word1?.location)
            XCTAssert(word1?.score >= 0.9)
            XCTAssertEqual(word1?.word, "notice")
            
            // verify the second word
            let word2 = image?.words[1]
            XCTAssertEqual(word2?.lineNumber, 1)
            XCTAssertNotNil(word2?.location)
            XCTAssert(word2?.score >= 0.9)
            XCTAssertEqual(word2?.word, "increased")
            
            // verify the third word
            let word3 = image?.words[2]
            XCTAssertEqual(word3?.lineNumber, 2)
            XCTAssertNotNil(word3?.location)
            XCTAssert(word3?.score >= 0.9)
            XCTAssertEqual(word3?.word, "train")
            
            // verify the fourth word
            let word4 = image?.words[3]
            XCTAssertEqual(word4?.lineNumber, 2)
            XCTAssertNotNil(word4?.location)
            XCTAssert(word4?.score >= 0.9)
            XCTAssertEqual(word4?.word, "traffic")
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
