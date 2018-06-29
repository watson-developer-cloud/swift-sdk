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
    private let timeout: TimeInterval = 10.0

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        instantiateSpeechToText()
    }

    func instantiateSpeechToText() {
        let username = Credentials.SpeechToTextUsername
        let password = Credentials.SpeechToTextPassword
        speechToText = SpeechToText(username: username, password: password)
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
        ]
    }

    // MARK: - State Management

    func lookupOrCreateTestLanguageModel() -> LanguageModel {
        var languageModel: LanguageModel!
        let expectation = self.expectation(description: "listLanguageModels")
        let failure = { (error: Error) in XCTFail("Failed to lookup languageModel: \(error.localizedDescription)") }
        speechToText.listLanguageModels(failure: failure) {
            response in
            languageModel = response.customizations.first { $0.name == "swift-test-model" }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return languageModel ?? self.createTestLanguageModel()
    }

    func createTestLanguageModel() -> LanguageModel {
        var languageModel: LanguageModel!
        let expectation = self.expectation(description: "createLanguageModel")
        let options = CreateLanguageModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel")
        let failure = { (error: Error) in XCTFail(error.localizedDescription) }
        speechToText.createLanguageModel(createLanguageModel: options, failure: failure) {
            model in
            languageModel = model
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return languageModel
    }

    func lookupOrCreateTestAcousticModel() -> AcousticModel {
        var acousticModel: AcousticModel!
        let expectation = self.expectation(description: "listAcousticModels")
        let failure = { (error: Error) in
            XCTFail("Failed to lookup acousticModel: \(error.localizedDescription)") }
        speechToText.listAcousticModels(failure: failure) {
            response in
            acousticModel = response.customizations.first { $0.name == "swift-test-model" }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return acousticModel ?? self.createTestAcousticModel()
    }

    func createTestAcousticModel() -> AcousticModel {
        var acousticModel: AcousticModel!
        let expectation = self.expectation(description: "createAcousticModel")
        let failure = { (error: Error) in XCTFail(error.localizedDescription) }
        speechToText.createAcousticModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel", failure: failure) {
            model in
            acousticModel = model
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
        return acousticModel
    }

    func addTrainingData(to languageModel: LanguageModel) {
        let expectation = self.expectation(description: "addCorpus")
        let file = Bundle(for: type(of: self)).url(forResource: "healthcare-short", withExtension: "txt")!
        let failure = { (error: Error) in XCTFail(error.localizedDescription) }
        speechToText.addCorpus(
            customizationID: languageModel.customizationID,
            corpusName: "swift-test-corpus",
            corpusFile: file,
            allowOverwrite: true,
            corpusFileContentType: "plain/text",
            failure: failure)
        {
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
            contentType: "audio/wav",
            allowOverwrite: true,
            failure: failWithError)
        {
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
            let failure = { (error: Error) in if !error.localizedDescription.contains("locked") { XCTFail(error.localizedDescription) }}
            speechToText.getLanguageModel(customizationID: languageModel.customizationID, failure: failure) { model in
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
            let failure = { (error: Error) in if !error.localizedDescription.contains("locked") { XCTFail(error.localizedDescription) }}
            speechToText.getAcousticModel(customizationID: acousticModel.customizationID, failure: failure) { model in
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
            let failure = { (error: Error) in if !error.localizedDescription.contains("locked") { XCTFail(error.localizedDescription) }}
            speechToText.getCorpus(customizationID: languageModel.customizationID, corpusName: corpus, failure: failure) { corpus in
                hasDesiredStatus = (corpus.status == status)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: timeout)
            return hasDesiredStatus
        }
    }

    // MARK: - Helper Functions

    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    func failWithResult() {
        XCTFail("Negative test returned a result.")
    }

    // MARK: - Models

    func testListModels() {
        let expectation = self.expectation(description: "listModels")
        speechToText.listModels(failure: failWithError) { results in
            XCTAssertGreaterThan(results.models.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGetModel() {
        let expectation = self.expectation(description: "getModel")
        let modelID = "en-US_BroadbandModel"
        speechToText.getModel(modelID: modelID, failure: failWithError) { model in
            XCTAssertEqual(model.name, modelID)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Sessionless

    func testRecognizeSessionless() {
        let expectation = self.expectation(description: "recognizeSessionless")
        let audio = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "SpeechSample", withExtension: "wav")!)
        speechToText.recognizeSessionless(model: "en-US_BroadbandModel", audio: audio, contentType: "audio/wav", failure: failWithError) {
            recognitionResults in
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
        speechToText.createJob(audio: audio, contentType: "audio/wav", model: "en-US_BroadbandModel", failure: failWithError) {
            result in
            job = result
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // check the jobs
        let expectation2 = self.expectation(description: "checkJobs")
        speechToText.checkJobs(failure: failWithError) { result in
            XCTAssertGreaterThan(result.recognitions.count, 0)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // check the job we created
        let expectation3 = self.expectation(description: "checkJob")
        speechToText.checkJob(id: job.id, failure: failWithError) { result in
            XCTAssertEqual(result.id, job.id)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // register a callback
        let expectation4 = self.expectation(description: "registerCallback")
        let url = "https://watson-test-resources.mybluemix.net/speech-to-text-async/secure/callback"
        speechToText.registerCallback(callbackUrl: url, userSecret: "ThisIsMySecret", failure: failWithError) {
            status in
            XCTAssertEqual(status.url, url)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // unregister a callback
        let expectation5 = self.expectation(description: "unregisterCallback")
        speechToText.unregisterCallback(callbackUrl: url, failure: failWithError) {
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // delete the job we created
        let expectation6 = self.expectation(description: "deleteJob")
        speechToText.deleteJob(id: job.id, failure: failWithError) {
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

    }

    // MARK: - Custom Language Models

    func testLanguageModels() {

        // create a language model
        let expectation1 = self.expectation(description: "createLanguageModel")
        let createLanguageModel = CreateLanguageModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel", description: "Test model")
        var languageModel: LanguageModel!
        speechToText.createLanguageModel(createLanguageModel: createLanguageModel, failure: failWithError) { model in
            languageModel = model
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // list the language models
        let expectation2 = self.expectation(description: "listLanguageModels")
        speechToText.listLanguageModels(language: "en-US", failure: failWithError) { results in
            XCTAssertTrue(results.customizations.contains { $0.customizationID == languageModel.customizationID })
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get the language model
        let expectation3 = self.expectation(description: "getLanguageModel")
        speechToText.getLanguageModel(customizationID: languageModel.customizationID, failure: failWithError) { model in
            XCTAssertEqual(model.customizationID, languageModel.customizationID)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // add data before training
        addTrainingData(to: languageModel)

        // train the language model
        let expectation4 = self.expectation(description: "trainLanguageModel")
        speechToText.trainLanguageModel(customizationID: languageModel.customizationID, wordTypeToAdd: "all", customizationWeight: 0.3, failure: failWithError) {
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // wait for training to complete
        waitUntil(languageModel, is: "available")

        // reset the language model
        let expectation5 = self.expectation(description: "resetLanguageModel")
        speechToText.resetLanguageModel(customizationID: languageModel.customizationID, failure: failWithError) {
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // upgrade the language model
        let expectation6 = self.expectation(description: "upgradeLanguageModel")
        let failure = { (error: Error) in error.localizedDescription.contains("model is up-to-date") ? expectation6.fulfill() : XCTFail(error.localizedDescription) }
        speechToText.upgradeLanguageModel(customizationID: languageModel.customizationID, failure: failure) {
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

        // wait for upgrade to complete
        waitUntil(languageModel, is: "pending")

        // delete the language model
        let expectation7 = self.expectation(description: "deleteLanguageModel")
        speechToText.deleteLanguageModel(customizationID: languageModel.customizationID, failure: failWithError) {
            expectation7.fulfill()
        }
        wait(for: [expectation7], timeout: timeout)

    }

    // MARK: - Custom Corpora

    func testCustomCorpora() {

        // create or reuse an existing language model
        let languageModel = lookupOrCreateTestLanguageModel()

        // add a corpus to the language model
        let expectation1 = self.expectation(description: "addCorpus")
        let id = languageModel.customizationID
        let corpusName = "test-corpus"
        let file = Bundle(for: type(of: self)).url(forResource: "healthcare-short", withExtension: "txt")!
        speechToText.addCorpus(customizationID: id, corpusName: corpusName, corpusFile: file, allowOverwrite: true, corpusFileContentType: "plain/text", failure: failWithError) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // wait for corpus to be analyzed
        waitUntil(corpusName, is: "analyzed", languageModel: languageModel)

        // list all corpora
        let expectation2 = self.expectation(description: "listCorpora")
        speechToText.listCorpora(customizationID: languageModel.customizationID, failure: failWithError) { results in
            XCTAssertTrue(results.corpora.contains { $0.name == corpusName })
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get the corpus we added
        let expectation3 = self.expectation(description: "getCorpus")
        speechToText.getCorpus(customizationID: id, corpusName: corpusName, failure: failWithError) { corpus in
            XCTAssertEqual(corpus.name, corpusName)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // delete the corpus we added
        let expectation4 = self.expectation(description: "deleteCorpus")
        speechToText.deleteCorpus(customizationID: id, corpusName: corpusName, failure: failWithError) {
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

    }

    // MARK: - Custom Words

    func testCustomWords() {

        // create or reuse and existing language model
        let languageModel = lookupOrCreateTestLanguageModel()

        // add an array of words
        let expectation2 = self.expectation(description: "addWords")
        let word = CustomWord(word: "helllo", soundsLike: ["hello"], displayAs: "hello")
        speechToText.addWords(customizationID: languageModel.customizationID, words: [word], failure: failWithError) {
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // wait for array of words to be processed
        waitUntil(languageModel, is: "ready")

        // add a single word
        let expectation3 = self.expectation(description: "addWord")
        speechToText.addWord(customizationID: languageModel.customizationID, wordName: "worlld", soundsLike: ["world"], displayAs: "world", failure: failWithError) {
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // wait for single word to be processed
        waitUntil(languageModel, is: "ready")

        // list all words
        let expectation4 = self.expectation(description: "listWords")
        speechToText.listWords(customizationID: languageModel.customizationID, wordType: "user", sort: "+alphabetical", failure: failWithError) {
            results in
            XCTAssertEqual(results.words.count, 2)
            XCTAssertTrue(results.words.contains { $0.word == "helllo" })
            XCTAssertTrue(results.words.contains { $0.word == "worlld" })
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // get a word that we added
        let expectation5 = self.expectation(description: "getWord")
        speechToText.getWord(customizationID: languageModel.customizationID, wordName: "helllo", failure: failWithError) {
            word in
            XCTAssertEqual(word.word, "helllo")
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // delete a word that we added
        let expectation6 = self.expectation(description: "deleteWord")
        speechToText.deleteWord(customizationID: languageModel.customizationID, wordName: "helllo", failure: failWithError) {
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

    }

    // MARK: - Custom Acoustic Models

    func testAcousticModels() {

        // create an acoustic model
        let expectation1 = self.expectation(description: "createAcousticModel")
        var acousticModel: AcousticModel!
        speechToText.createAcousticModel(name: "swift-test-model", baseModelName: "en-US_BroadbandModel", description: "test", failure: failWithError) {
            model in
            acousticModel = model
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // list acoustic models
        let expectation2 = self.expectation(description: "listAcousticModels")
        speechToText.listAcousticModels(language: "en-US", failure: failWithError) {
            results in
            XCTAssertTrue(results.customizations.contains { $0.customizationID == acousticModel.customizationID })
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get the acoustic model
        let expectation3 = self.expectation(description: "getAcousticModel")
        speechToText.getAcousticModel(customizationID: acousticModel.customizationID, failure: failWithError) { model in
            XCTAssertEqual(model.customizationID, acousticModel.customizationID)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // add data before training
        addTrainingData(to: acousticModel)

        // train the acoustic model
        let expectation4 = self.expectation(description: "trainAcousticModel")
        let failure1 = { (error: Error) in error.localizedDescription.contains("audio duration must be between") ? expectation4.fulfill() : XCTFail(error.localizedDescription) }
        speechToText.trainAcousticModel(customizationID: acousticModel.customizationID, failure: failure1) {
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

        // wait for training to complete
        waitUntil(acousticModel, is: "available")

        // reset the acoustic model
        let expectation5 = self.expectation(description: "resetAcousticModel")
        speechToText.resetAcousticModel(customizationID: acousticModel.customizationID, failure: failWithError) {
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: timeout)

        // updgrade the acoustic model
        let expectation6 = self.expectation(description: "upgradeAcousticModel")
        let failure2 = { (error: Error) in error.localizedDescription.contains("model is up-to-date") ? expectation6.fulfill() : XCTFail(error.localizedDescription) }
        speechToText.upgradeAcousticModel(customizationID: acousticModel.customizationID, failure: failure2) {
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: timeout)

        // wait for upgrade to complete
        waitUntil(acousticModel, is: "pending")

        // delete the acoustic model
        let expectation7 = self.expectation(description: "deleteAcousticModel")
        speechToText.deleteAcousticModel(customizationID: acousticModel.customizationID, failure: failWithError) {
            expectation7.fulfill()
        }
        wait(for: [expectation7], timeout: timeout)

    }

    // MARK: - Custom Audio Resources

    func testCustomAudioResources() {

        // create or reuse and existing acoustic model
        let acousticModel = lookupOrCreateTestAcousticModel()

        // add audio resource to acoustic model
        let expectation1 = self.expectation(description: "addAudio")
        let audio = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "SpeechSample", withExtension: "wav")!)
        speechToText.addAudio(customizationID: acousticModel.customizationID, audioName: "audio", audioResource: audio, contentType: "audio/wav", allowOverwrite: true, failure: failWithError) {
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: timeout)

        // wait for audio resource to be processed
        waitUntil(acousticModel, is: "ready")

        // list audio resources
        let expectation2 = self.expectation(description: "listAudio")
        speechToText.listAudio(customizationID: acousticModel.customizationID, failure: failWithError) { results in
            XCTAssertGreaterThan(results.audio.count, 0)
            XCTAssertGreaterThan(results.totalMinutesOfAudio, 0.0)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: timeout)

        // get audio resource
        let expectation3 = self.expectation(description: "getAudio")
        speechToText.getAudio(customizationID: acousticModel.customizationID, audioName: "audio", failure: failWithError) {
            audio in
            XCTAssertEqual(audio.name, "audio")
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: timeout)

        // delete audio resource
        let expectation4 = self.expectation(description: "deleteAudio")
        speechToText.deleteAudio(customizationID: acousticModel.customizationID, audioName: "audio", failure: failWithError) {
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: timeout)

    }
}
