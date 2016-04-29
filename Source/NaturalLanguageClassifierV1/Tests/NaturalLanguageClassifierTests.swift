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
import WatsonDeveloperCloud

class NaturalLanguageClassifierTests: XCTestCase {
    
    private var naturalLanguageClassifier: NaturalLanguageClassifierV1!
    private let classifierName = "iOS SDK Test Classifier"
    private let timeout: NSTimeInterval = 30
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateNaturalLanguageClassifier()
        deleteStaleClassifiers()
    }
    
    /** Instantiate Natural Langauge Classifier instance. */
    func instantiateNaturalLanguageClassifier() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["NaturalLanguageClassifierUsername"],
            let password = credentials["NaturalLanguageClassifierPassword"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        naturalLanguageClassifier = NaturalLanguageClassifierV1(username: username, password: password)
    }
    
    /** Delete any stale classifiers previously created by unit tests. */
    func deleteStaleClassifiers() {
        let description = "Delete any stale classifiers previously created by unit tests."
        let expectation = expectationWithDescription(description)
        
        naturalLanguageClassifier.getClassifiers(failWithError) { classifiers in
            for classifier in classifiers {
                if let name = classifier.name {
                    if name.hasPrefix(self.classifierName) {
                        self.naturalLanguageClassifier.deleteClassifier(classifier.classifierId)
                    }
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
    
    // MARK: - Helper Functions
    
    /** Load a file used when creating a classifier. */
    func loadClassifierFile(name: String, withExtension: String) -> NSURL? {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.URLForResource(name, withExtension: withExtension) else {
            return nil
        }
        return url
    }
    
    /** Create a classifier. */
    func createClassifier(classifierName: String) -> NaturalLanguageClassifierV1.ClassifierDetails? {
        let description = "Create a classifier."
        let expectation = expectationWithDescription(description)
        var classifierDetails: NaturalLanguageClassifierV1.ClassifierDetails?
        
        guard let trainingMetadataURL = loadClassifierFile("training_meta", withExtension: "txt"),
            let trainingDataURL = loadClassifierFile("weather_data_train", withExtension: "csv") else {
                XCTFail("Failed to load files needed to create a classifier")
                return nil
        }
        
        naturalLanguageClassifier.createClassifier(trainingMetadataURL, trainingData: trainingDataURL, failure: failWithError) {
            details in
            
            classifierDetails = details
            expectation.fulfill()
        }
        
        waitForExpectations()
        return classifierDetails
    }
    
    /** Delete the classifier created during testing. */
    func deleteClassifier(classifierId: String) {
        let description = "Delete the classifier created during testing."
        let expectation = expectationWithDescription(description)
        
        naturalLanguageClassifier.deleteClassifier(classifierId, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Positive Tests
    
    /** List all classifiers associated with this service instance */
    func testGetClassifiers() {
        let description = "Get all classifiers."
        let expectation = expectationWithDescription(description)
        
        naturalLanguageClassifier.getClassifiers(failWithError) { classifiers in
            XCTAssertGreaterThan(classifiers.count, 0, "Expected at least 1 classifier to be returned.")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete a classifier */
    func testCreateDelete() {
        guard let classifier = createClassifier(classifierName) else {
            XCTFail("Failed to create the classifier.")
            return
        }
        
        deleteClassifier(classifier.classifierId)
    }
}
