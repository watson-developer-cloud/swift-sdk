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
import NaturalLanguageClassifierV1

class NaturalLanguageClassifierTests: XCTestCase {
    
    private var naturalLanguageClassifier: NaturalLanguageClassifier!
    private let newClassifierName = "Swift SDK Test Classifier"
    private let trainedClassifierId = "2a3230x98-nlc-61"
    private let timeout: NSTimeInterval = 5.0
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateNaturalLanguageClassifier()
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
        naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)
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
    func createClassifier(trainingMetaFileName: String, trainingDataFileName: String) -> NaturalLanguageClassifierV1.ClassifierDetails? {
        let description = "Create a classifier."
        let expectation = expectationWithDescription(description)
        var classifierDetails: NaturalLanguageClassifierV1.ClassifierDetails?
        
        guard let trainingMetadataURL = loadClassifierFile(trainingMetaFileName, withExtension: "txt"),
            let trainingDataURL = loadClassifierFile(trainingDataFileName, withExtension: "csv") else {
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
    
    /** Get all classifiers. */
    func getAllClassifiers() -> [NaturalLanguageClassifierV1.ClassifierModel]? {
        let description = "Get all classifiers."
        let expectation = expectationWithDescription(description)
        var classifiersList: [NaturalLanguageClassifierV1.ClassifierModel]?
        
        naturalLanguageClassifier.getClassifiers(failWithError) { classifiers in
            classifiersList = classifiers
            expectation.fulfill()
        }
        waitForExpectations()
        return classifiersList
    }
    
    /** Get information about a classifier. */
    func getClassifier(classifierId: String) -> NaturalLanguageClassifierV1.ClassifierDetails? {
        let description = "Get information about the classifier."
        let expectation = expectationWithDescription(description)
        var classifierDetails: NaturalLanguageClassifierV1.ClassifierDetails?
        
        naturalLanguageClassifier.getClassifier(classifierId, failure: failWithError) { details in
            classifierDetails = details
            expectation.fulfill()
        }
        waitForExpectations()
        return classifierDetails
    }
    
    /** Classify some text. */
    func classifyText(text: String, classifierId: String) -> NaturalLanguageClassifierV1.Classification? {
        let description = "Classify the given text using the classifier created for these unit tests."
        let expectation = expectationWithDescription(description)
        var classificationDetails: NaturalLanguageClassifierV1.Classification?
        
        naturalLanguageClassifier.classify(classifierId, text: text, failure: failWithError) { classification in
            classificationDetails = classification
            expectation.fulfill()
        }
        waitForExpectations()
        return classificationDetails
    }
    
    /** Attempt to get the trained classifier; if it doesn't exist, created one. */
    func lookupTrainedClassifier(classifierId: String) {
        let description = "Ensure the given trained classifier is available."
        let expectation = expectationWithDescription(description)
        
        func createTrainedClassifier() {
            guard let trainingMetadataURL = loadClassifierFile("trained_meta", withExtension: "txt"),
                let trainingDataURL = loadClassifierFile("weather_data_train", withExtension: "csv") else {
                    XCTFail("Failed to load files needed to create a classifier")
                    return
            }
            let failToCreate =  { (error: NSError) in
                XCTFail("Failed to create the trained classifier.")
            }
            naturalLanguageClassifier.createClassifier(trainingMetadataURL, trainingData: trainingDataURL, failure: failToCreate) {
                classifier in
                XCTAssertNotNil(classifier)
                XCTAssertNotEqual("", classifier.classifierId, "Expected to get an id")
                let message = "A trained classifier was not found. It has been created and " +
                    "is currently being trained. You will need to set the " +
                    "trainedClassifierID property using the classifier id " +
                    "printed below. Then wait a few minutes for training to " +
                "complete before running the tests again.\n"
                print(message)
                print("** trainedClassifierID: \(classifier.classifierId)\n")
                XCTFail("Trained classifier not found. Set trainedClassifierID and try again.")
            }
        }
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404, "Cannot locate the trained classifier.")
            createTrainedClassifier()
            expectation.fulfill()
        }
            
        naturalLanguageClassifier.getClassifier(classifierId, failure: failure) { classifier in
            if classifier.name != "Trained Classifier" {
                let message = "The wrong classifier was provided as a trained " +
                "classifier. The trained classifier will be recreated."
                print(message)
                createTrainedClassifier()
                return
            }
            if classifier.status != NaturalLanguageClassifierV1.ClassifierStatus.Available {
                XCTFail("Please wait. The given classifier is still being trained.")
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations()
    }
    
    // MARK: - Positive Tests
    
    /** Test successfuly creating a classifier */
    func testCreateAndDelete() {
        
        guard let classifier = createClassifier("training_meta", trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        XCTAssertEqual(classifier.name, newClassifierName, "Expected created classifier to be named \(newClassifierName)")
        XCTAssertEqual(classifier.language, "en", "Expected created classifier language to be English.")
        
        deleteClassifier(classifier.classifierId)
    }
    
    /** Test that creating a classifier without providing a name is successful */
    func testCreateAndDeleteClassifierWithoutOptionalName() {
        
        guard let classifier = createClassifier("training_meta_missing_name", trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        XCTAssertEqual(classifier.name, nil, "Expected classifier name to be nil.")
        XCTAssertEqual(classifier.language, "en", "Expected created classifier language to be English.")
        
        deleteClassifier(classifier.classifierId)
    }
    
    /** List all classifiers associated with this service instance */
    func testGetAllClassifiers() {
        
        guard let classifier = createClassifier("training_meta", trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        guard let classifiers = getAllClassifiers() else {
            XCTFail("Failed to list all classifiers.")
            return
        }
        
        XCTAssertGreaterThanOrEqual(classifiers.count, 2, "Expected there to be at least 2 classifiers.")
        
        deleteClassifier(classifier.classifierId)
    }
    
    /** Test getting the classifier that was created for this test. */
    func testGetClassifier() {
        
        guard let classifier = createClassifier("training_meta", trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        guard let classifierDetails = getClassifier(classifier.classifierId) else {
            XCTFail("Failed to get the newly created classifier.")
            return
        }
        
        XCTAssertEqual(classifierDetails.name, newClassifierName, "Expected the classifier we got to have the correct name.")
        XCTAssertEqual(classifierDetails.url, classifier.url, "The classifier we got back should have the expected URL.")
        
        deleteClassifier(classifier.classifierId)
    }
    
    /** Classify the given text using a trained classifier. */
    func testClassify() {
        lookupTrainedClassifier(trainedClassifierId)
        
        guard let classification = classifyText("How hot will it be today?", classifierId: trainedClassifierId) else {
            XCTFail("Failed to classify the text.")
            return
        }
        
        XCTAssertEqual(classification.topClass, "temperature", "Expected the top class returned to be temperature.")
        XCTAssertEqual(classification.classes.count, 2, "Expected there to be two classes returned.")
    }
    
    // MARK: - Negative Tests
    
    /** Create a classifier with missing metadata. */
    func testCreateClassifierWithMissingMetadata() {
        let description = "Create a classifier with a file that is missing metadata."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        guard let trainingMetadataURL = loadClassifierFile("training_meta_empty", withExtension: "txt"),
            let trainingDataURL = loadClassifierFile("weather_data_train", withExtension: "csv") else {
                XCTFail("Failed to load files needed to create a classifier")
                return
        }
        
        naturalLanguageClassifier.createClassifier(trainingMetadataURL, trainingData: trainingDataURL, failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to classify an empty string. */
    func testClassifyEmptyString() {
        let description = "Attempt to classify an empty string."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.classify(trainedClassifierId, text: "", failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to classify a string by using a classifier that doesn't exist. */
    func testClassifyWithInvalidClassifier() {
        let description = "Attempt to classify a string by using a classifier that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.classify("InvalidClassifierID", text: "How hot will it be today?", failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to delete a classifier that doesn't exist. */
    func testDeleteInvalidClassifier() {
        let description = "Attempt to delete a classifier that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.deleteClassifier("InvalidClassifierID", failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Try to get information about a classifier that doesn't exist. */
    func testGetInvalidClassifier() {
        let description = "Attempt to get information about a classifier that doesn't exist."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.getClassifier("InvalidClassifierID", failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
}
