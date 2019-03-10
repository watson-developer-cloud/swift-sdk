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

// swiftlint:disable function_body_length force_try force_unwrapping file_length

import XCTest
import Foundation
import SpeechToTextV1

class SpeechToTextTests: XCTestCase {

    private var speechToText: SpeechToText!
    private let timeout: TimeInterval = 20.0
    private let litePlanMessage = "This feature is not available for the Bluemix Lite plan."

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        instantiateSpeechToText()
    }

    func instantiateSpeechToText() {
        if let apiKey = WatsonCredentials.SpeechToTextAPIKey {
            speechToText = SpeechToText(apiKey: apiKey)
        } else {
            let username = WatsonCredentials.SpeechToTextUsername
            let password = WatsonCredentials.SpeechToTextPassword
            speechToText = SpeechToText(username: username, password: password)
        }
        if let url = WatsonCredentials.SpeechToTextURL {
            speechToText.serviceURL = url
        }
        speechToText.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        speechToText.defaultHeaders["X-Watson-Test"] = "true"
    }

    // MARK: - Test Definition for Linux

    static var allTests: [(String, (SpeechToTextTests) -> () throws -> Void)] {
        return [
            ("testListModels", testListModels),
            ("testGetModel", testGetModel),
            ("testRecognizeSessionless", testRecognizeSessionless),
            ("testAsynchronous", testAsynchronous),
            ("testLanguageModels", testLanguageModels),
            ("testCustomCorpora", testCustomCorpora),
            ("testCustomWords", testCustomWords),
            ("testAcousticModels", testAcousticModels),
            ("testCustomAudioResources", testCustomAudioResources),
            ("testGrammarsOperations", testGrammarsOperations)
        ]
    }

    // MARK: - State Management

    func lookupOrCreateTestLanguageModel() -> LanguageModel? {
        var languageModel: LanguageModel?
        let expectation = self.expectation(description: "listLanguageModels")
        speechToText.listLanguageModels {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail("Lookup for languageModel failed: \(error)")
                }
                expectation.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            languageModel = result.customizations.first { $0.name == "swift-test-model" }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return languageModel ?? self.createTestLanguageModel()
    }

    func createTestLanguageModel() -> LanguageModel? {
        var languageModel: LanguageModel?
        let expectation = self.expectation(description: "createLanguageModel")
        speechToText.createLanguageModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel") {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail("Create for languageModel failed: \(error)")
                }
                expectation.fulfill()
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            languageModel = model
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return languageModel
    }

    func lookupOrCreateTestAcousticModel() -> AcousticModel? {
        var acousticModel: AcousticModel?
        let expectation = self.expectation(description: "listAcousticModels")
        speechToText.listAcousticModels {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail("Lookup for acousticModel failed: \(error)")
                }
                expectation.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            acousticModel = result.customizations.first { $0.name == "swift-test-model" }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return acousticModel ?? self.createTestAcousticModel()
    }

    func createTestAcousticModel() -> AcousticModel? {
        var acousticModel: AcousticModel?
        let expectation = self.expectation(description: "createAcousticModel")
        speechToText.createAcousticModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel") {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail("Lookup for languageModel failed: \(error)")
                }
                expectation.fulfill()
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            acousticModel = model
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return acousticModel
    }

    func addTrainingData(to languageModel: LanguageModel) {
        let expectation = self.expectation(description: "addCorpus")
        let file = Bundle(for: type(of: self)).url(forResource: "healthcare-short", withExtension: "txt")!
        let fileData = try! Data(contentsOf: file)
        speechToText.addCorpus(
            customizationID: languageModel.customizationID,
            corpusName: "swift-test-corpus",
            corpusFile: fileData,
            allowOverwrite: true)
        {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        waitUntil(languageModel, is: "ready")
    }

    func addTrainingData(to acousticModel: AcousticModel) {
        let expectation = self.expectation(description: "addAudio")
        let audio = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "SpeechSample", withExtension: "wav")!)
        speechToText.addAudio(
            customizationID: acousticModel.customizationID,
            audioName: "audio",
            audioResource: audio,
            allowOverwrite: true,
            contentType: "audio/wav")
        {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        waitUntil(acousticModel, is: "ready")
    }

    // MARK: - Wait Functions

    func waitUntil(maxRetries: Int = 5, condition: () -> Bool) {
        let sleepTime: UInt32 = 5
        for retry in 1 ... maxRetries {
            if !condition() && retry < maxRetries {
                sleep(sleepTime)
            } else {
                break
            }
        }
    }

    func waitUntil(_ languageModel: LanguageModel, is status: String) {
        waitUntil(maxRetries: 12) {
            var hasDesiredStatus = false
            let expectation = self.expectation(description: "getLanguageModel")
            speechToText.getLanguageModel(customizationID: languageModel.customizationID) {
                response, error in
                if let error = error {
                    if !error.localizedDescription.contains("locked") {
                        XCTFail(unexpectedErrorMessage(error))
                    }
                    expectation.fulfill()
                    return
                }
                guard let model = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                hasDesiredStatus = (model.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }

    func waitUntil(_ acousticModel: AcousticModel, is status: String) {
        waitUntil {
            var hasDesiredStatus = false
            let expectation = self.expectation(description: "getAcousticModel")
            speechToText.getAcousticModel(customizationID: acousticModel.customizationID) {
                response, error in
                if let error = error {
                    if !error.localizedDescription.contains("locked") {
                        XCTFail(unexpectedErrorMessage(error))
                    }
                    expectation.fulfill()
                    return
                }
                guard let model = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                hasDesiredStatus = (model.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }

    func waitUntil(_ corpus: String, is status: String, languageModel: LanguageModel) {
        waitUntil {
            var hasDesiredStatus = false
            let expectation = self.expectation(description: "getCorpus")
            speechToText.getCorpus(customizationID: languageModel.customizationID, corpusName: corpus) {
                response, error in
                if let error = error {
                    if !error.localizedDescription.contains("locked") {
                        XCTFail(unexpectedErrorMessage(error))
                    }
                    expectation.fulfill()
                    return
                }
                guard let corpus = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                hasDesiredStatus = (corpus.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }

    // MARK: - Models

    func testListModels() {
        let expectation = self.expectation(description: "listModels")
        speechToText.listModels {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(result.models.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGetModel() {
        let expectation = self.expectation(description: "getModel")
        let modelID = "en-US_BroadbandModel"
        speechToText.getModel(modelID: modelID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(model.name, modelID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Sessionless

    func testRecognizeSessionless() {
        let expectation = self.expectation(description: "recognizeSessionless")
        let audio = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "SpeechSample", withExtension: "wav")!)
        speechToText.recognize(audio: audio, model: "en-US_BroadbandModel", contentType: "audio/wav") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let recognitionResults = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertNotNil(recognitionResults.results)
            XCTAssertGreaterThan(recognitionResults.results!.count, 0)
            XCTAssertTrue(recognitionResults.results!.first!.finalResults)
            XCTAssertGreaterThan(recognitionResults.results!.first!.alternatives.count, 0)
            XCTAssertTrue(recognitionResults.results!.first!.alternatives.first!.transcript.contains("tornadoes"))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Asynchronous

    func testAsynchronous() {

        // create an asynchronous job
        let expectation1 = self.expectation(description: "createJob")
        let audio = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "SpeechSample", withExtension: "wav")!)
        var job: RecognitionJob!
        speechToText.createJob(audio: audio, model: "en-US_BroadbandModel", contentType: "audio/wav") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            job = result
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // check the jobs
        let expectation2 = self.expectation(description: "checkJobs")
        speechToText.checkJobs {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(result.recognitions.count, 0)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // check the job we created
        let expectation3 = self.expectation(description: "checkJob")
        speechToText.checkJob(id: job.id) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(result.id, job.id)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // register a callback
        let expectation4 = self.expectation(description: "registerCallback")
        let url = "https://watson-test-resources.mybluemix.net/speech-to-text-async/secure/callback"
        speechToText.registerCallback(callbackURL: url, userSecret: "ThisIsMySecret") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let status = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(status.url, url)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // unregister a callback
        let expectation5 = self.expectation(description: "unregisterCallback")
        speechToText.unregisterCallback(callbackURL: url) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // delete the job we created
        let expectation6 = self.expectation(description: "deleteJob")
        speechToText.deleteJob(id: job.id) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

    }

    // MARK: - Custom Language Models

    func testLanguageModels() {

        // create a language model
        let expectation1 = self.expectation(description: "createLanguageModel")
        var languageModel: LanguageModel!
        speechToText.createLanguageModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel", description: "Test model") {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation1.fulfill()
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            languageModel = model
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // If the create request failed, skip the rest of the test.
        guard languageModel != nil else {
            return
        }

        // list the language models
        let expectation2 = self.expectation(description: "listLanguageModels")
        speechToText.listLanguageModels(language: "en-US") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertTrue(result.customizations.contains { $0.customizationID == languageModel.customizationID })
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get the language model
        let expectation3 = self.expectation(description: "getLanguageModel")
        speechToText.getLanguageModel(customizationID: languageModel.customizationID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(model.customizationID, languageModel.customizationID)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // add data before training
        addTrainingData(to: languageModel)

        // train the language model
        let expectation4 = self.expectation(description: "trainLanguageModel")
        speechToText.trainLanguageModel(customizationID: languageModel.customizationID, wordTypeToAdd: "all", customizationWeight: 0.3) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // wait for training to complete
        waitUntil(languageModel, is: "available")

        // reset the language model
        let expectation5 = self.expectation(description: "resetLanguageModel")
        speechToText.resetLanguageModel(customizationID: languageModel.customizationID) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // upgrade the language model
        let expectation6 = self.expectation(description: "upgradeLanguageModel")
        speechToText.upgradeLanguageModel(customizationID: languageModel.customizationID) {
            _, error in
            if let error = error {
                if !error.localizedDescription.contains("model is up-to-date") {
                    XCTFail(unexpectedErrorMessage(error))
                }
            }
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

        // wait for upgrade to complete
        waitUntil(languageModel, is: "pending")

        // delete the language model
        let expectation7 = self.expectation(description: "deleteLanguageModel")
        speechToText.deleteLanguageModel(customizationID: languageModel.customizationID) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation7.fulfill()
        }
        wait(for: [expectation7], timeout: timeout)

    }

    // MARK: - Custom Corpora

    func testCustomCorpora() {

        // create or reuse an existing language model
        guard let languageModel = lookupOrCreateTestLanguageModel() else {
            return
        }

        // add a corpus to the language model
        let expectation1 = self.expectation(description: "addCorpus")
        let id = languageModel.customizationID
        let corpusName = "test-corpus"
        let file = Bundle(for: type(of: self)).url(forResource: "healthcare-short", withExtension: "txt")!
        let fileData = try! Data(contentsOf: file)
        speechToText.addCorpus(customizationID: id, corpusName: corpusName, corpusFile: fileData, allowOverwrite: true) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // wait for corpus to be analyzed
        waitUntil(corpusName, is: "analyzed", languageModel: languageModel)

        // list all corpora
        let expectation2 = self.expectation(description: "listCorpora")
        speechToText.listCorpora(customizationID: languageModel.customizationID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertTrue(result.corpora.contains { $0.name == corpusName })
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get the corpus we added
        let expectation3 = self.expectation(description: "getCorpus")
        speechToText.getCorpus(customizationID: id, corpusName: corpusName) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let corpus = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(corpus.name, corpusName)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // delete the corpus we added
        let expectation4 = self.expectation(description: "deleteCorpus")
        speechToText.deleteCorpus(customizationID: id, corpusName: corpusName) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

    }

    // MARK: - Custom Words

    func testCustomWords() {

        // create or reuse and existing language model
        guard let languageModel = lookupOrCreateTestLanguageModel() else {
            return
        }

        // add an array of words
        let expectation2 = self.expectation(description: "addWords")
        let word = CustomWord(word: "helllo", soundsLike: ["hello"], displayAs: "hello")
        speechToText.addWords(customizationID: languageModel.customizationID, words: [word]) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // wait for array of words to be processed
        waitUntil(languageModel, is: "ready")

        // add a single word
        let expectation3 = self.expectation(description: "addWord")
        speechToText.addWord(customizationID: languageModel.customizationID, wordName: "worlld", soundsLike: ["world"], displayAs: "world") {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // wait for single word to be processed
        waitUntil(languageModel, is: "ready")

        // list all words
        let expectation4 = self.expectation(description: "listWords")
        speechToText.listWords(customizationID: languageModel.customizationID, wordType: "user", sort: "+alphabetical") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(result.words.count, 2)
            XCTAssertTrue(result.words.contains { $0.word == "helllo" })
            XCTAssertTrue(result.words.contains { $0.word == "worlld" })
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // get a word that we added
        let expectation5 = self.expectation(description: "getWord")
        speechToText.getWord(customizationID: languageModel.customizationID, wordName: "helllo") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let word = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(word.word, "helllo")
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // delete a word that we added
        let expectation6 = self.expectation(description: "deleteWord")
        speechToText.deleteWord(customizationID: languageModel.customizationID, wordName: "helllo") {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

    }

    // MARK: - Grammars

    func testGrammarsOperations() {
        let expectation1 = self.expectation(description: "addGrammar")

        // create or reuse an existing language model
        guard let languageModel = lookupOrCreateTestLanguageModel() else {
            return
        }
        let customizationID = languageModel.customizationID
        let grammarName = "swift-sdk-test-grammar"
        let grammarFile = Bundle(for: type(of: self)).url(forResource: "confirm", withExtension: "abnf")!
        speechToText.addGrammar(
            customizationID: customizationID,
            grammarName: grammarName,
            grammarFile: grammarFile.absoluteString,
            contentType: "application/srgs",
            allowOverwrite: true)
        {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            expectation1.fulfill()
        }

        wait(for: [expectation1], timeout: timeout)

        let expectation2 = self.expectation(description: "getGrammar")

        speechToText.getGrammar(customizationID: customizationID, grammarName: grammarName) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let grammar = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(grammar.name, grammarName)
            expectation2.fulfill()
        }

        wait(for: [expectation2], timeout: timeout)

        let expectation3 = self.expectation(description: "listGrammars")

        speechToText.listGrammars(customizationID: customizationID) {
            response, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let grammars = response?.result?.grammars else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssert(grammars.count > 0)
            let foundGrammar = grammars.first(where: { grammar -> Bool in
                grammar.name == grammarName
            })
            XCTAssertNotNil(foundGrammar)
            expectation3.fulfill()
        }

        wait(for: [expectation3], timeout: timeout)

        let expectation4 = self.expectation(description: "deleteGrammar")

        // Can't delete the grammar until the Language model (with the customizationID) is no longer process-locked
        waitUntil(languageModel, is: "ready")

        speechToText.deleteGrammar(customizationID: customizationID, grammarName: grammarName) {
            _, error in

            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            expectation4.fulfill()
        }

        wait(for: [expectation4], timeout: timeout)
    }

    // MARK: - Custom Acoustic Models

    func testAcousticModels() {

        // create an acoustic model
        let expectation1 = self.expectation(description: "createAcousticModel")
        var acousticModel: AcousticModel!
        speechToText.createAcousticModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel", description: "test") {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation1.fulfill()
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            acousticModel = model
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // If the create request failed, skip the rest of the test.
        guard acousticModel != nil else {
            return
        }

        // list acoustic models
        let expectation2 = self.expectation(description: "listAcousticModels")
        speechToText.listAcousticModels(language: "en-US") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertTrue(result.customizations.contains { $0.customizationID == acousticModel.customizationID })
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get the acoustic model
        let expectation3 = self.expectation(description: "getAcousticModel")
        speechToText.getAcousticModel(customizationID: acousticModel.customizationID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let model = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(model.customizationID, acousticModel.customizationID)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // add data before training
        addTrainingData(to: acousticModel)

        // train the acoustic model
        let expectation4 = self.expectation(description: "trainAcousticModel")
        speechToText.trainAcousticModel(customizationID: acousticModel.customizationID) {
            _, error in
            if let error = error {
                if !error.localizedDescription.contains("audio duration must be between") {
                    XCTFail(unexpectedErrorMessage(error))
                }
            }
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // wait for training to complete
        waitUntil(acousticModel, is: "available")

        // reset the acoustic model
        let expectation5 = self.expectation(description: "resetAcousticModel")
        speechToText.resetAcousticModel(customizationID: acousticModel.customizationID) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // upgrade the acoustic model
        let expectation6 = self.expectation(description: "upgradeAcousticModel")
        speechToText.upgradeAcousticModel(customizationID: acousticModel.customizationID) {
            _, error in
            if let error = error {
                if !error.localizedDescription.contains("model is up-to-date") {
                    XCTFail(unexpectedErrorMessage(error))
                }
            }
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

        // wait for upgrade to complete
        waitUntil(acousticModel, is: "pending")

        // delete the acoustic model
        let expectation7 = self.expectation(description: "deleteAcousticModel")
        speechToText.deleteAcousticModel(customizationID: acousticModel.customizationID) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation7.fulfill()
        }
        wait(for: [expectation7], timeout: timeout)

    }

    // MARK: - Custom Audio Resources

    func testCustomAudioResources() {

        // create or reuse and existing acoustic model
        guard let acousticModel = lookupOrCreateTestAcousticModel() else {
            return
        }

        // add audio resource to acoustic model
        let expectation1 = self.expectation(description: "addAudio")
        let audio = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "SpeechSample", withExtension: "wav")!)
        speechToText.addAudio(customizationID: acousticModel.customizationID, audioName: "audio", audioResource: audio, allowOverwrite: true, contentType: "audio/wav") {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // wait for audio resource to be processed
        waitUntil(acousticModel, is: "ready")

        // list audio resources
        let expectation2 = self.expectation(description: "listAudio")
        speechToText.listAudio(customizationID: acousticModel.customizationID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(result.audio.count, 0)
            XCTAssertGreaterThan(result.totalMinutesOfAudio, 0.0)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get audio resource
        let expectation3 = self.expectation(description: "getAudio")
        speechToText.getAudio(customizationID: acousticModel.customizationID, audioName: "audio") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let audio = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(audio.name, "audio")
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // delete audio resource
        let expectation4 = self.expectation(description: "deleteAudio")
        speechToText.deleteAudio(customizationID: acousticModel.customizationID, audioName: "audio") {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

    }
}
