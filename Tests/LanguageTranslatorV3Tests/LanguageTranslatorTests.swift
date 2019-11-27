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
import LanguageTranslatorV3

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
            // Models
            ("testListModelsAll", testListModelsAll),
            ("testListModelsBySourceLanguage", testListModelsBySourceLanguage),
            ("testListModelsByTargetLanguage", testListModelsByTargetLanguage),
            ("testListModelsDefault", testListModelsDefault),
            ("testCreateDeleteModel", testCreateDeleteModel),
            ("testGetModel", testGetModel),
            // Translation
            ("testTranslateStringWithModelID", testTranslateStringWithModelID),
            ("testTranslateStringWithSourceAndTarget", testTranslateStringWithSourceAndTarget),
            // Identification
            ("testListIdentifiableLanguages", testListIdentifiableLanguages),
            ("testIdentify", testIdentify),
            // Document Translation
            ("testListDocuments", testListDocuments),
            ("testDocumentsCRUD", testDocumentsCRUD),
            // Negative Tests
            ("testGetModelDoesntExist", testGetModelDoesntExist),
        ]
    }

    /** Instantiate Language Translator. */
    func instantiateLanguageTranslator() {
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.LanguageTranslatorV3APIKey)
        languageTranslator = LanguageTranslator(version: versionDate, authenticator: authenticator)

        if let url = WatsonCredentials.LanguageTranslatorV3URL {
            languageTranslator.serviceURL = url
        }
        languageTranslator.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        languageTranslator.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Delete any stale custom models that were previously created by unit tests. */
    func deleteStaleCustomModels() {
        let description = "Delete any stale custom models previously created by unit tests."
        let expectation = self.expectation(description: description)
        languageTranslator.listModels(default: false) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let models = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            for model in models.models where model.baseModelID != "" {
                self.languageTranslator.deleteModel(modelID: model.modelID) {
                    _, error in

                    if let error = error {
                        XCTFail(unexpectedErrorMessage(error))
                        return
                    }
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 20.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Models

    func testListModelsAll() {
        let expectation = self.expectation(description: "List all models.")
        languageTranslator.listModels {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let models = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModelsBySourceLanguage() {
        let expectation = self.expectation(description: "List models, filtered by source language.")
        languageTranslator.listModels(source: "es") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let models = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModelsByTargetLanguage() {
        let expectation = self.expectation(description: "List models, filtered by target language.")
        languageTranslator.listModels(target: "pt") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let models = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListModelsDefault() {
        let expectation = self.expectation(description: "List models, filtered by default models.")
        languageTranslator.listModels(default: true) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let models = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(models.models.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateDeleteModel() {
        let expectation = self.expectation(description: "Create and delete a custom language model.")

        #if os(Linux)
            let url = URL(fileURLWithPath: "Tests/LanguageTranslatorV3Tests/Resources/glossary.tmx")
        #else
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: "glossary", withExtension: "tmx") else {
                XCTFail("Unable to read forced glossary.")
                return
            }
        #endif
        let glossary = try? Data(contentsOf: url)

        languageTranslator.createModel(baseModelID: "en-es", forcedGlossary: glossary, name: "custom-english-to-spanish-model") {
            response, error in

            if let error = error {
                if error.localizedDescription.contains("does not permit customization") {
                    expectation.fulfill()
                    return
                } else {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotEqual(model.modelID, "")
            self.languageTranslator.deleteModel(modelID: model.modelID) {
                _, error in

                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testGetModel() {
        let expectation = self.expectation(description: "Get model.")
        languageTranslator.getModel(modelID: "en-es") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(model.status, TranslationModel.Status.available.rawValue)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Translation

    func testTranslateStringWithModelID() {
        let expectation = self.expectation(description: "Translate text string using model id.")
        languageTranslator.translate(text: ["Hello"], modelID: "en-es") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let translation = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translation, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testTranslateStringWithSourceAndTarget() {
        let expectation = self.expectation(description: "Translate text string using source and target.")
        languageTranslator.translate(text: ["Hello"], source: "en", target: "es") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let translation = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(translation.wordCount, 1)
            XCTAssertEqual(translation.characterCount, 5)
            XCTAssertEqual(translation.translations.count, 1)
            XCTAssertEqual(translation.translations.first?.translation, "Hola")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Identification

    func testListIdentifiableLanguages() {
        let expectation = self.expectation(description: "List identifiable languages.")
        languageTranslator.listIdentifiableLanguages {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let identifiableLanguages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(identifiableLanguages.languages.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testIdentify() {
        let expectation = self.expectation(description: "Identify")
        languageTranslator.identify(text: "Hola") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let identifiableLanguages = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            let languages = identifiableLanguages.languages
            XCTAssertGreaterThan(languages.count, 0)
            XCTAssertEqual(languages.first?.language, "es")
            XCTAssertGreaterThanOrEqual(languages.first!.confidence, 0.0)
            XCTAssertLessThanOrEqual(languages.first!.confidence, 1.0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Document Translation

    func testListDocuments() {
        let expectation = self.expectation(description: "List documents.")
        languageTranslator.listDocuments {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let documents = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertNotNil(documents.documents, "Documents array does not exist!")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDocumentsCRUD() {
        let filename = "common-phrases.pptx"
        #if os(Linux)
        let url = URL(fileURLWithPath: "Tests/LanguageTranslatorV3Tests/Resources/" + filename)
        #else
        let bundle = Bundle(for: type(of: self))
        let filenameParts = filename.components(separatedBy: ".")
        guard let url = bundle.url(forResource: filenameParts[0], withExtension: filenameParts[1]) else {
            XCTFail("Unable to read document.")
            return
        }
        #endif
        let document = try? Data(contentsOf: url)

        var documentID: String!
        let expectation1 = self.expectation(description: "Translate document.")
        languageTranslator.translateDocument(file: document!, filename: filename, modelID: "en-es") {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let documentStatus = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(filename, documentStatus.filename)
            documentID = documentStatus.documentID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard documentID != nil else {
            // If the create failed, skip remainder of the test
            return
        }

        var status = ""
        let expectation2 = self.expectation(description: "Get document status.")
        languageTranslator.getDocumentStatus(documentID: documentID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let documentStatus = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertEqual(filename, documentStatus.filename)
            status = documentStatus.status
            expectation2.fulfill()
        }
        waitForExpectations()

        // Make sure translation is available before attempting to retrieve it

        var tries = 0
        while status != DocumentStatus.Status.available.rawValue {
            sleep(15)
            let expectation = self.expectation(description: "Get document status.")
            languageTranslator.getDocumentStatus(documentID: documentID) {
                response, _ in
                status = response?.result?.status ?? "unknown"
                expectation.fulfill()
            }
            waitForExpectations()
            tries += 1
            if tries > 4 {
                XCTFail("Document translation did not complete within allowed time interval")
                return
            }
        }

        let expectation3 = self.expectation(description: "Get translated document.")
        languageTranslator.getTranslatedDocument(documentID: documentID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let document = response?.result else {
                XCTFail(missingResultMessage)
                return
            }

            XCTAssertGreaterThan(document.count, 0)  // document has content
            let contentType = response?.headers
                                .first { $0.key.compare("content-type", options: .caseInsensitive) == .orderedSame }
                                .map { $0.value }
            XCTAssertNotNil(contentType)
            expectation3.fulfill()
        }
        waitForExpectations()

        let expectation4 = self.expectation(description: "Delete document.")
        languageTranslator.deleteDocument(documentID: documentID) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }

            expectation4.fulfill()
        }
        waitForExpectations()

    }

    // MARK: - Negative Tests

    func testGetModelDoesntExist() {
        let expectation = self.expectation(description: "Get model with invalid model id")
        languageTranslator.getModel(modelID: "invalid_model_id") {
            _, error in

            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
