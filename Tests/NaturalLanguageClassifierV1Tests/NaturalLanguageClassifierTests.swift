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
import Foundation
import NaturalLanguageClassifierV1

class NaturalLanguageClassifierTests: XCTestCase {
    
    private var naturalLanguageClassifier: NaturalLanguageClassifier!
    private let newClassifierName = "Swift SDK Test Classifier"
    private let trainedClassifierId = "2a3230x98-nlc-61"
    private let timeout: TimeInterval = 5.0
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateNaturalLanguageClassifier()
    }
    
    static var allTests : [(String, (NaturalLanguageClassifierTests) -> () throws -> Void)] {
        return [
            ("testCreateAndDelete", testCreateAndDelete),
            ("testCreateAndDeleteClassifierWithoutOptionalName", testCreateAndDeleteClassifierWithoutOptionalName),
            ("testGetAllClassifiers", testGetAllClassifiers),
            ("testGetClassifier", testGetClassifier),
            ("testClassify", testClassify),
            ("testCreateClassifierWithMissingMetadata", testCreateClassifierWithMissingMetadata),
            ("testClassifyEmptyString", testClassifyEmptyString),
            ("testClassifyWithInvalidClassifier", testClassifyWithInvalidClassifier),
            ("testDeleteInvalidClassifier", testDeleteInvalidClassifier),
            ("testGetInvalidClassifier", testGetInvalidClassifier)
        ]
    }
    
    /** Instantiate Natural Langauge Classifier instance. */
    func instantiateNaturalLanguageClassifier() {
        let username = Credentials.NaturalLanguageClassifierUsername
        let password = Credentials.NaturalLanguageClassifierPassword
        naturalLanguageClassifier = NaturalLanguageClassifier(username: username, password: password)
        naturalLanguageClassifier.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        naturalLanguageClassifier.defaultHeaders["X-Watson-Test"] = "true"
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
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Helper Functions
    
    /** Load a file used when creating a classifier. */
    func loadClassifierFile(withName name: String, withExtension: String) -> URL? {
        
        #if os(iOS)
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: name, withExtension: withExtension) else {
                return nil
            }
        #else
            let url = URL(fileURLWithPath: "Tests/NaturalLanguageClassifierV1Tests/"+name+"."+withExtension)
        #endif
        
        return url
    }
    
    /** Create a classifier. */
    func createClassifier(trainingMetaFileName: String, trainingDataFileName: String) -> NaturalLanguageClassifierV1.ClassifierDetails? {
        let description = "Create a classifier."
        let expectation = self.expectation(description: description)
        var classifierDetails: NaturalLanguageClassifierV1.ClassifierDetails?
        
        guard let trainingMetadataURL = loadClassifierFile(withName: trainingMetaFileName, withExtension: "txt"),
            let trainingDataURL = loadClassifierFile(withName: trainingDataFileName, withExtension: "csv") else {
                XCTFail("Failed to load files needed to create a classifier")
                return nil
        }
        
        naturalLanguageClassifier.createClassifier(fromMetadataFile: trainingMetadataURL,
                                                   andTrainingFile: trainingDataURL,
                                                   failure: failWithError) { details in
            classifierDetails = details
            expectation.fulfill()
        }
        
        waitForExpectations()
        return classifierDetails
    }
    
    /** Delete the classifier created during testing. */
    func deleteClassifier(withID classifierId: String) {
        let description = "Delete the classifier created during testing."
        let expectation = self.expectation(description: description)
        
        naturalLanguageClassifier.deleteClassifier(withID: classifierId, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Get all classifiers. */
    func getAllClassifiers() -> [NaturalLanguageClassifierV1.ClassifierModel]? {
        let description = "Get all classifiers."
        let expectation = self.expectation(description: description)
        var classifiersList: [NaturalLanguageClassifierV1.ClassifierModel]?
        
        naturalLanguageClassifier.getClassifiers(failure: failWithError) { classifiers in
            classifiersList = classifiers
            expectation.fulfill()
        }
        waitForExpectations()
        return classifiersList
    }
    
    /** Get information about a classifier. */
    func getClassifier(withID classifierId: String) -> NaturalLanguageClassifierV1.ClassifierDetails? {
        let description = "Get information about the classifier."
        let expectation = self.expectation(description: description)
        var classifierDetails: NaturalLanguageClassifierV1.ClassifierDetails?
        
        naturalLanguageClassifier.getClassifier(withID: classifierId, failure: failWithError) { details in
            classifierDetails = details
            expectation.fulfill()
        }
        waitForExpectations()
        return classifierDetails
    }
    
    /** Classify some text. */
    func classifyText(_ text: String, usingID classifierId: String) -> NaturalLanguageClassifierV1.Classification? {
        let description = "Classify the given text using the classifier created for these unit tests."
        let expectation = self.expectation(description: description)
        var classificationDetails: NaturalLanguageClassifierV1.Classification?
        
        naturalLanguageClassifier.classify(text, withClassifierID: classifierId,
                                           failure: failWithError) { classification in
            classificationDetails = classification
            expectation.fulfill()
        }
        waitForExpectations()
        return classificationDetails
    }
    
    /** Attempt to get the trained classifier; if it doesn't exist, created one. */
    func lookupTrainedClassifier(classifierId: String) {
        let description = "Ensure the given trained classifier is available."
        let expectation = self.expectation(description: description)
        
        func createTrainedClassifier() {
            guard let trainingMetadataURL = loadClassifierFile(withName: "trained_meta", withExtension: "txt"),
                let trainingDataURL = loadClassifierFile(withName: "weather_data_train", withExtension: "csv") else {
                    XCTFail("Failed to load files needed to create a classifier")
                    return
            }
            let failToCreate =  { (error: Error) in
                XCTFail("Failed to create the trained classifier.")
            }
            naturalLanguageClassifier.createClassifier(fromMetadataFile: trainingMetadataURL,
                                                       andTrainingFile: trainingDataURL,
                                                       failure: failToCreate) { classifier in
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
        
        let failure = { (error: Error) in
            createTrainedClassifier()
            expectation.fulfill()
        }
            
        naturalLanguageClassifier.getClassifier(withID: classifierId, failure: failure) { classifier in
            if classifier.name != "Trained Classifier" {
                let message = "The wrong classifier was provided as a trained " +
                "classifier. The trained classifier will be recreated."
                print(message)
                createTrainedClassifier()
                return
            }
            if classifier.status != NaturalLanguageClassifierV1.ClassifierStatus.available {
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
        
        guard let classifier = createClassifier(trainingMetaFileName: "training_meta",
                                                trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        XCTAssertEqual(classifier.name, newClassifierName, "Expected created classifier to be named \(newClassifierName)")
        XCTAssertEqual(classifier.language, "en", "Expected created classifier language to be English.")
        
        deleteClassifier(withID: classifier.classifierId)
    }
    
    /** Test that creating a classifier without providing a name is successful */
    func testCreateAndDeleteClassifierWithoutOptionalName() {
        
        guard let classifier = createClassifier(trainingMetaFileName: "training_meta_missing_name",
                                                trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        XCTAssertEqual(classifier.name, nil, "Expected classifier name to be nil.")
        XCTAssertEqual(classifier.language, "en", "Expected created classifier language to be English.")
        
        deleteClassifier(withID: classifier.classifierId)
    }
    
    /** List all classifiers associated with this service instance */
    func testGetAllClassifiers() {
        
        guard let classifier = createClassifier(trainingMetaFileName: "training_meta",
                                                trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        guard let classifiers = getAllClassifiers() else {
            XCTFail("Failed to list all classifiers.")
            return
        }
        
        XCTAssertGreaterThanOrEqual(classifiers.count, 2, "Expected there to be at least 2 classifiers.")
        
        deleteClassifier(withID: classifier.classifierId)
    }
    
    /** Test getting the classifier that was created for this test. */
    func testGetClassifier() {
        
        guard let classifier = createClassifier(trainingMetaFileName: "training_meta",
                                                trainingDataFileName: "weather_data_train") else {
            XCTFail("Failed to create a new classifier.")
            return
        }
        
        guard let classifierDetails = getClassifier(withID: classifier.classifierId) else {
            XCTFail("Failed to get the newly created classifier.")
            return
        }
        
        XCTAssertEqual(classifierDetails.name, newClassifierName, "Expected the classifier we got to have the correct name.")
        XCTAssertEqual(classifierDetails.url, classifier.url, "The classifier we got back should have the expected URL.")
        
        deleteClassifier(withID: classifier.classifierId)
    }
    
    /** Classify the given text using a trained classifier. */
    func testClassify() {
        lookupTrainedClassifier(classifierId: trainedClassifierId)
        
        guard let classification = classifyText("How hot will it be today?",
                                                usingID: trainedClassifierId) else {
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
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        guard let trainingMetadataURL = loadClassifierFile(withName: "training_meta_empty", withExtension: "txt"),
            let trainingDataURL = loadClassifierFile(withName: "weather_data_train", withExtension: "csv") else {
                XCTFail("Failed to load files needed to create a classifier")
                return
        }
        
        naturalLanguageClassifier.createClassifier(fromMetadataFile: trainingMetadataURL,
                                                   andTrainingFile: trainingDataURL,
                                                   failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to classify an empty string. */
    func testClassifyEmptyString() {
        let description = "Attempt to classify an empty string."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.classify("", withClassifierID: trainedClassifierId,
                                           failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to classify a string by using a classifier that doesn't exist. */
    func testClassifyWithInvalidClassifier() {
        let description = "Attempt to classify a string by using a classifier that doesn't exist."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.classify("How hot will it be today?",
                                           withClassifierID: "InvalidClassifierID",
                                           failure: failure, success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Attempt to delete a classifier that doesn't exist. */
    func testDeleteInvalidClassifier() {
        let description = "Attempt to delete a classifier that doesn't exist."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.deleteClassifier(withID: "InvalidClassifierID", failure: failure,
                                                   success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Try to get information about a classifier that doesn't exist. */
    func testGetInvalidClassifier() {
        let description = "Attempt to get information about a classifier that doesn't exist."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        naturalLanguageClassifier.getClassifier(withID: "InvalidClassifierID", failure: failure,
                                                success: failWithResult)
        
        waitForExpectations()
    }
}
