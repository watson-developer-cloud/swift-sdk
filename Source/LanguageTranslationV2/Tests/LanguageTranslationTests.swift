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
import LanguageTranslationV2

class LanguageTranslationTests: XCTestCase {

    private var languageTranslation: LanguageTranslation!
    private let timeout: NSTimeInterval = 30

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateLanguageTranslation()
    }

    /** Instantiate Language Translation. */
    func instantiateLanguageTranslation() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["LanguageTranslationUsername"],
            let password = credentials["LanguageTranslationPassword"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        languageTranslation = LanguageTranslation(username: username, password: password)
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

    /** Get all models. */
    func testGetModelsAll() {
        let description = "Get all models."
        let expectation = expectationWithDescription(description)

        languageTranslation.getModels(failure: failWithError) { models in
            XCTAssertGreaterThan(models.count, 0, "Expected at least 1 model to be returned.")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Get models, filtered by source language. */
    func testGetModelsBySourceLanguage() {
        let description = "Get models, filtered by source language."
        let expectation = expectationWithDescription(description)

        languageTranslation.getModels(source: "es", failure: failWithError) { models in
            XCTAssertGreaterThan(models.count, 0, "Expected at least 1 model to be returned.")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Get models, filtered by target language. */
    func testGetModelsByTargetLanguage() {
        let description = "Get models, filtered by target language."
        let expectation = expectationWithDescription(description)

        languageTranslation.getModels(target: "pt", failure: failWithError) { models in
            XCTAssertGreaterThan(models.count, 0, "Expected at least 1 model to be returned.")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Get models, filtered by default models. */
    func testGetModelsDefault() {
        let description = "Get models, filtered to include only default models."
        let expectation = expectationWithDescription(description)

        languageTranslation.getModels(defaultModelsOnly: true, failure: failWithError) { models in
            XCTAssertGreaterThan(models.count, 0, "Expected at least 1 model to be returned.")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Create and delete a custom model. */
    func testCreateDeleteModel() {
        let creationDescription = "Create a custom language model."
        let creationExpectation = expectationWithDescription(creationDescription)
        let deletionDescription = "Delete the custom language model."
        let deletionExpectation = expectationWithDescription(deletionDescription)

        let bundle = NSBundle(forClass: self.dynamicType)
        guard let glossary = bundle.URLForResource("glossary", withExtension: "tmx") else {
            XCTFail("Unable to read forced glossary.")
            return
        }

        languageTranslation.createModel("en-es", name: "custom-english-to-spanish-model",
            forcedGlossary: glossary, failure: failWithError)
        {
            modelID in
            XCTAssertNotEqual(modelID, "")
            creationExpectation.fulfill()

            self.languageTranslation.deleteModel(modelID, failure: self.failWithError) {
                deletionExpectation.fulfill()
            }
        }
        waitForExpectations()
    }

    /** Get a model's training status. */
    func testGetModel() {
        let description = "Get a model's training status."
        let expectation = expectationWithDescription(description)

        languageTranslation.getModel("en-es", failure: failWithError) { monitorTraining in
            XCTAssertEqual(monitorTraining.status, LanguageTranslationV2.TrainingStatus.Available)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Translate a text string, specifying the model by model id. */
    func testTranslateStringWithModelID() {
        let description = "Translate text string, specifying the model by model id."
        let expectation = expectationWithDescription(description)

        let text = "Hello"
        let modelID = "en-es-conversational"
        languageTranslation.translate(text, modelID: modelID, failure: failWithError) {
            translation in
            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translation, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Translate a text array, specifying the model by model id. */
    func testTranslateArrayWithModelID() {
        let description = "Translate text array, specifying the model by model id."
        let expectation = expectationWithDescription(description)

        let text = ["Hello"]
        let modelID = "en-es-conversational"
        languageTranslation.translate(text, modelID: modelID, failure: failWithError) {
            translation in
            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translation, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Translate a text string, specifying the model by source and target language. */
    func testTranslateStringWithSourceAndTarget() {
        let description = "Translate text string, specifying the model by source and target."
        let expectation = expectationWithDescription(description)

        languageTranslation.translate("Hello", source: "en", target: "es", failure: failWithError) {
            translation in
            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translation, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Translate a text array, specifying the model by source and target language. */
    func testTranslateArrayWithSourceAndTarget() {
        let description = "Translate text array, specifying the model by source and target."
        let expectation = expectationWithDescription(description)

        languageTranslation.translate(["Hello"], source: "en", target: "es", failure: failWithError) {
            translation in
            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translation, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Get all identifiable languages. */
    func testGetIdentifiableLanguages() {
        let description = "Get all identifiable languages."
        let expectation = expectationWithDescription(description)

        languageTranslation.getIdentifiableLanguages(failWithError) { languages in
            XCTAssertGreaterThan(languages.count, 0, "Expected at least 1 language to be returned.")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Identify the language of a text string. */
    func testIdentify() {
        let description = "Identify the language of a text string."
        let expectation = expectationWithDescription(description)

        languageTranslation.identify("Hola", failure: failWithError) { languages in
            XCTAssertGreaterThan(languages.count, 0, "Expected at least 1 language to be returned.")
            XCTAssertEqual(languages.first?.language, "es")
            XCTAssertGreaterThanOrEqual(languages.first!.confidence, 0.0)
            XCTAssertLessThanOrEqual(languages.first!.confidence, 1.0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    /** Try to get information about a model that doesn't exit. */
    func testGetModelDoesntExit() {
        let description = "Try to get information about a model that doesn't exist."
        let expectation = expectationWithDescription(description)

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        languageTranslation.getModel("invalid_model_id", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Try to delete a model created by IBM. */
    func testDeleteUnauthorized() {
        let description = "Try to delete a model that was created by IBM."
        let expectation = expectationWithDescription(description)

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        languageTranslation.deleteModel("en-es", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Try to delete a model that does not exist. */
    func testDeleteNotFound() {
        let description = "Try to delete a model that does not exist."
        let expectation = expectationWithDescription(description)

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }

        languageTranslation.deleteModel("qwerty", failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
