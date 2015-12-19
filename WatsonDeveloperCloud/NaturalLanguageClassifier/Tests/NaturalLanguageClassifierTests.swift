/**
 * Copyright IBM Corporation 2015
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
@testable import WatsonDeveloperCloud

class NaturalLanguageClassifierTests: XCTestCase {
    
    // MARK: - Parameters and constants
    
    // the NaturalLanguageClassifier service
    var service: NaturalLanguageClassifier!
    
    // a classifier that is already trained with the given weather data
    let trainedClassifierID = "A3FCCBx16-nlc-248"
    let trainedClassifierName = "iOS SDK Test Classifier"
    let availableStatus = NaturalLanguageClassifier.Status.Available
    
    // the classifier that will be created then deleted during tests
    var temporaryClassifierID: String!
    
    // timeout for asynchronous completion handlers
    let timeout: NSTimeInterval = 30.0
    
    // MARK: - Helper functions
    
    // Load credentials and instantiate NLC service
    override func setUp() {
        super.setUp()
        
        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }
        
        // load credentials from file
        let dict = NSDictionary(contentsOfFile: url)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }
        
        // read NLC username
        guard let username = credentials["NaturalLanguageClassifierUsername"] else {
            XCTFail("Unable to read NaturalLanguageClassifier username.")
            return
        }
        
        // read NLC password
        guard let password = credentials["NaturalLanguageClassifierPassword"] else {
            XCTFail("Unable to read NaturalLanguageClassifier password.")
            return
        }
        
        // instantiate the service
        if service == nil {
            service = NaturalLanguageClassifier(username: username, password: password)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Wait for an expectation to be fulfilled
    func waitForExpectation() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout.")
        }
    }
    
    // MARK: - Positive test: create, list, lookup, then delete
    
    func testCreateListLookupDelete() {
        createClassifier()
        verifyListOfClassifiers()
        lookupClassifier()
        deleteClassifier()
    }
    
    func createClassifier() {
        let description = "Create a classifier."
        let expectation = expectationWithDescription(description)
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let trainerURL = bundle.URLForResource("weather_data_train", withExtension: "csv")
        let trainerMetaURL = bundle.URLForResource("training_meta", withExtension: "txt")
        
        service.createClassifier(trainerMetaURL!, trainerURL: trainerURL!) {
            classifier, error in
            XCTAssertNotNil(classifier)
            XCTAssertNotEqual("", classifier!.id, "Expected to get an id")
            XCTAssertNil(error)
            self.temporaryClassifierID = classifier!.id
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    func verifyListOfClassifiers() {
        let description = "Check the list of classifiers to ensure ours was created."
        let expectation = expectationWithDescription(description)
        
        service.getClassifiers { classifiers, error in
            XCTAssertNotNil(classifiers)
            XCTAssertNil(error)
            for classifier in classifiers! {
                if classifier.id == self.temporaryClassifierID {
                    expectation.fulfill()
                    break
                }
            }
        }
        waitForExpectation()
    }
    
    func lookupClassifier() {
        let description = "Lookup our classifier to get its properties."
        let expectation = expectationWithDescription(description)
        
        service.getClassifier(temporaryClassifierID) { classifier, error in
            XCTAssertNotNil(classifier)
            XCTAssertNil(error)
            XCTAssertEqual(classifier!.id, self.temporaryClassifierID)
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    func deleteClassifier() {
        let description = "Delete the classifier we created for this test."
        let expectation = expectationWithDescription(description)
        
        service.deleteClassifier(temporaryClassifierID) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // MARK: - Positive test: classify
    
    func testClassifyWithTrainedClassifier() {
        lookupTrainedClassifier()
        classify()
    }
    
    func lookupTrainedClassifier() {
        let description = "Ensure the given trained classifier is available."
        let expectation = expectationWithDescription(description)
        
        func createTrainedClassifier() {
            let bundle = NSBundle(forClass: self.dynamicType)
            let trainerURL = bundle.URLForResource("weather_data_train", withExtension: "csv")
            let trainerMetaURL = bundle.URLForResource("training_meta", withExtension: "txt")
            
            service.createClassifier(trainerMetaURL!, trainerURL: trainerURL!) {
                classifier, error in
                XCTAssertNotNil(classifier)
                XCTAssertNotEqual("", classifier!.id, "Expected to get an id")
                XCTAssertNil(error)
                let message = "A trained classifier was not found. It has been created and " +
                              "is currently being trained. You will need to set the " +
                              "trainedClassifierID property using the classifier id " +
                              "printed below. Then wait a few minutes for training to " +
                              "complete before running the tests again.\n"
                print(message)
                print("** trainedClassifierID: \(classifier!.id)\n")
                XCTFail("Trained classifier not found. Set trainedClassifierID and try again.")
            }
        }
        
        service.getClassifier(trainedClassifierID) { classifier, error in
            if let error = error {
                XCTAssertEqual(error.code, 404, "Cannot locate the trained classifier.")
            }
            
            guard let classifier = classifier else {
                createTrainedClassifier()
                return
            }
            
            guard classifier.name == self.trainedClassifierName else {
                let message = "The wrong classifier was provided as a trained " +
                              "classifier. The trained classifier will be recreated."
                print(message)
                createTrainedClassifier()
                return
            }
            
            guard classifier.status == self.availableStatus else {
                XCTFail("Please wait. The given classifier is still being trained.")
                return
            }
            
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    func createTrainedClassifier() {
        let description = "Create and train a classifier for future tests."
        let expectation = expectationWithDescription(description)
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let trainerURL = bundle.URLForResource("weather_data_train", withExtension: "csv")
        let trainerMetaURL = bundle.URLForResource("training_meta", withExtension: "txt")
        
        service.createClassifier(trainerMetaURL!, trainerURL: trainerURL!) {
            classifier, error in
            XCTAssertNotNil(classifier)
            XCTAssertNotEqual("", classifier!.id, "Expected to get an id")
            XCTAssertNil(error)
            let message = "A trained classifier was not found. It has been created and " +
                          "is currently being trained. You will need to set the " +
                          "trainedClassifierID property using the classifier id " +
                          "printed below. Then wait a few minutes for training to " +
                          "complete before running the tests again.\n\n"
            print(message)
            print("trainedClassifierID: \(classifier!.id)")
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // please note this test expects the classifier to be available
    func classify() {
        let description = "Classify the string: `is it sunny?`"
        let expectation = expectationWithDescription(description)
        
        service.classify(trainedClassifierID, text: "is it sunny?") { classification, error in
            XCTAssertNotNil(classification)
            XCTAssertEqual(classification!.id, self.trainedClassifierID)
            XCTAssertGreaterThan(classification!.classes!.count, 1)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    // MARK: - Negative tests
    
    func testCreateClassifierWithEmptyFile() {
        let description = "Try to create a classifier with an empty file."
        let expectation = expectationWithDescription(description)
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let trainerURL = bundle.URLForResource("weather_data_train", withExtension: "csv")
        let emptyFileURL = bundle.URLForResource("missing_training_meta", withExtension: "txt")
        
        service.createClassifier(emptyFileURL!, trainerURL: trainerURL!) {
            classifier, error in
            XCTAssertNil(classifier)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.code, 400)
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    func testLookupUnknownClassifier() {
        let description = "Try to lookup a classifier that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        service.getClassifier("MISSING_CLASSIFIER_ID") { classifier, error in
            XCTAssertNil(classifier)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.code, 404)
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    func testDeleteUnknownClassifier() {
        let description = "Try to delete a classifier that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        service.deleteClassifier("MISSING_CLASSIFIER_ID") { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        waitForExpectation()
    }
    
    func testClassifyWithUnknownClassifier() {
        let description = "Try to classify with a classifier that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        service.classify("MISSING_CLASSIFIER_ID", text: "is it sunny?") {
            classification, error in
            XCTAssertNil(classification)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!.code, 404)
            expectation.fulfill()
        }
        waitForExpectation()
    }
}