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
import LanguageTranslatorV2

class LanguageTranslatorTests: XCTestCase {

    private var languageTranslator: LanguageTranslator!

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateLanguageTranslator()
        deleteStaleCustomModels()
    }

    static var allTests: [(String, (LanguageTranslatorTests) -> () throws -> Void)] {
        return [
            ("testListModelsAll", testListModelsAll),
            ("testListModelsBySourceLanguage", testListModelsBySourceLanguage),
            ("testListModelsByTargetLanguage", testListModelsByTargetLanguage),
            ("testListModelsDefault", testListModelsDefault),
            ("testCreateDeleteModel", testCreateDeleteModel),
            ("testGetModel", testGetModel),
            ("testTranslateStringWithModelID", testTranslateStringWithModelID),
            ("testTranslateStringWithSourceAndTarget", testTranslateStringWithSourceAndTarget),
            ("testListIdentifiableLanguages", testListIdentifiableLanguages),
            ("testIdentify", testIdentify),
            ("testGetModelDoesntExist", testGetModelDoesntExist),
        ]
    }

    /** Instantiate Language Translator. */
    func instantiateLanguageTranslator() {
        let username = Credentials.LanguageTranslatorUsername
        let password = Credentials.LanguageTranslatorPassword
        languageTranslator = LanguageTranslator(username: username, password: password)
        languageTranslator.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        languageTranslator.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Delete any stale custom models that were previously created by unit tests. */
    func deleteStaleCustomModels() {
        let description = "Delete any stale custom models previously created by unit tests."
        let expectation = self.expectation(description: description)
        languageTranslator.listModels(defaultModels: false, failure: failWithError) { models in
            for model in models.models where model.baseModelID != "" {
                self.languageTranslator.deleteModel(modelID: model.modelID, failure: self.failWithError) { _ in }
            }
            expectation.fulfill()
        }
        waitForExpectations()
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
    func waitForExpectations(timeout: TimeInterval = 20.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    func testListModelsAll() {
        let expectation = self.expectation(description: "List all models.")
        languageTranslator.listModels(failure: failWithError) { models in
            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModelsBySourceLanguage() {
        let expectation = self.expectation(description: "List models, filtered by source language.")
        languageTranslator.listModels(source: "es", failure: failWithError) { models in
            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModelsByTargetLanguage() {
        let expectation = self.expectation(description: "List models, filtered by target language.")
        languageTranslator.listModels(target: "pt", failure: failWithError) { models in
            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModelsDefault() {
        let expectation = self.expectation(description: "List models, filtered by default models.")
        languageTranslator.listModels(defaultModels: true, failure: failWithError) { models in
            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateDeleteModel() {
        let creationExpectation = self.expectation(description: "Create a custom language model.")
        let deletionExpectation = self.expectation(description: "Delete the custom language model.")

        #if os(Linux)
            let glossary = URL(fileURLWithPath: "Tests/LanguageTranslatorV2Tests/glossary.tmx")
        #else
            let bundle = Bundle(for: type(of: self))
            guard let glossary = bundle.url(forResource: "glossary", withExtension: "tmx") else {
                XCTFail("Unable to read forced glossary.")
                return
            }
        #endif

        languageTranslator.createModel(
            baseModelID: "en-es",
            name: "custom-english-to-spanish-model",
            forcedGlossary: glossary,
            failure: failWithError)
        {
            model in
            XCTAssertNotEqual(model.modelID, "")
            creationExpectation.fulfill()
            self.languageTranslator.deleteModel(modelID: model.modelID, failure: self.failWithError) { _ in
                deletionExpectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testGetModel() {
        let expectation = self.expectation(description: "Get model.")
        languageTranslator.getModel(modelID: "en-es", failure: failWithError) { model in
            XCTAssertEqual(model.status, TranslationModel.Status.available.rawValue)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testTranslateStringWithModelID() {
        let expectation = self.expectation(description: "Translate text string using model id.")
        let request = TranslateRequest(text: ["Hello"], modelID: "en-es-conversational")
        languageTranslator.translate(request: request, failure: failWithError) {
            translation in
            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translationOutput, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testTranslateStringWithSourceAndTarget() {
        let expectation = self.expectation(description: "Translate text string using source and target.")
        let request = TranslateRequest(text: ["Hello"], source: "en", target: "es")
        languageTranslator.translate(request: request, failure: failWithError) {
            translation in
            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translationOutput, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListIdentifiableLanguages() {
        let expectation = self.expectation(description: "List identifiable languages.")
        languageTranslator.listIdentifiableLanguages(failure: failWithError) { identifiableLanguages in
            XCTAssertGreaterThan(identifiableLanguages.languages.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testIdentify() {
        let expectation = self.expectation(description: "Identify")
        languageTranslator.identify(text: "Hola", failure: failWithError) { identifiableLanguages in
            let languages = identifiableLanguages.languages
            XCTAssertGreaterThan(languages.count, 0)
            XCTAssertEqual(languages.first?.language, "es")
            XCTAssertGreaterThanOrEqual(languages.first!.confidence, 0.0)
            XCTAssertLessThanOrEqual(languages.first!.confidence, 1.0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testGetModelDoesntExist() {
        let expectation = self.expectation(description: "Get model with invalid model id")
        let failure = { (error: Error) in expectation.fulfill() }
        languageTranslator.getModel(modelID: "invalid_model_id", failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
