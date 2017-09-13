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

import XCTest
import Foundation
import SpeechToTextV1

class SpeechToTextTests: XCTestCase {

    private var speechToText: SpeechToText!
    private let timeout: TimeInterval = 15.0
    private let trainedCustomizationName = "swift-sdk-unit-test-trained-customization"
    private let trainedCustomizationDescription = "swift sdk test customization"
    private var trainedCustomizationID: String!
    private let corpusName = "swift-sdk-unit-test-corpus"
    
    static var allTests : [(String, (SpeechToTextTests) -> () throws -> Void)] {
        return [
            ("testModels", testModels),
            ("testTranscribeWithCustomModel", testTranscribeWithCustomModel),
            ("testGetAllCustomModels", testGetAllCustomModels),
            ("testCreateAndDeleteCustomModel", testCreateAndDeleteCustomModel),
            ("testListTrainedCustomModelDetails", testListTrainedCustomModelDetails),
            ("testGetAllCorpora", testGetAllCorpora),
            ("testCreateAndDeleteCorpus", testCreateAndDeleteCorpus),
            ("testGetCorpusForTrainedCustomization", testGetCorpusForTrainedCustomization),
            ("testGetAllWords", testGetAllWords),
            ("testAddAndDeleteMultipleWords", testAddAndDeleteMultipleWords),
            ("testAddAndDeleteASingleWord", testAddAndDeleteASingleWord),
            ("testGetWord", testGetWord),
            ("testTranscribeFileDefaultWAV", testTranscribeFileDefaultWAV),
            ("testTranscribeFileDefaultOpus", testTranscribeFileDefaultOpus),
            ("testTranscribeFileDefaultFLAC", testTranscribeFileDefaultFLAC),
            ("testTranscribeFileCustomWAV", testTranscribeFileCustomWAV),
            ("testTranscribeFileCustomOpus", testTranscribeFileCustomOpus),
            ("testTranscribeFileCustomFLAC", testTranscribeFileCustomFLAC),
            ("testTranscribeDataDefaultWAV", testTranscribeDataDefaultWAV),
            ("testTranscribeDataDefaultOpus", testTranscribeDataDefaultOpus),
            ("testTranscribeDataDefaultFLAC", testTranscribeDataDefaultFLAC),
            ("testTranscribeDataCustomWAV", testTranscribeDataCustomWAV),
            ("testTranscribeDataCustomOpus", testTranscribeDataCustomOpus),
            ("testTranscribeDataCustomFLAC", testTranscribeDataCustomFLAC),
            ("testTranscribeStockAnnouncementCustomWAV", testTranscribeStockAnnouncementCustomWAV),
            ("testTranscribeDataWithSpeakerLabelsWAV", testTranscribeDataWithSpeakerLabelsWAV),
            ("testTranscribeDataWithSpeakerLabelsOpus", testTranscribeDataWithSpeakerLabelsOpus),
            ("testTranscribeDataWithSpeakerLabelsFLAC", testTranscribeDataWithSpeakerLabelsFLAC),
            ("testTranscribeStreaming", testTranscribeStreaming)
        ]
    }

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        instantiateSpeechToText()
        lookupCustomization()
    }
    
    /** Instantiate Speech to Text. */
    func instantiateSpeechToText() {
        let username = Credentials.SpeechToTextUsername
        let password = Credentials.SpeechToTextPassword
        speechToText = SpeechToText(username: username, password: password)
        speechToText.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        speechToText.defaultHeaders["X-Watson-Test"] = "true"
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
    
    /** Load files needed for the following unit tests. */
    private func loadFile(name: String, withExtension: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: withExtension) else {
            return nil
        }
        return url
    }
    
    /** Look up (or create) the trained customization. */
    func lookupCustomization() {
        let description = "Look up the trained customization."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            XCTFail("Failed to list customizations for this service instance.")
            return
        }
        
        var customizationStatus: CustomizationStatus?
        
        speechToText.getCustomizations(failure: failure) { customizations in
            for customization in customizations {
                if customization.name == self.trainedCustomizationName {
                    self.trainedCustomizationID = customization.customizationID
                    customizationStatus = customization.status
                }
            }
            expectation.fulfill()
        }
        waitForExpectations()
        
        if(trainedCustomizationID == nil) {
            print("Trained customization does not exist; creating a new one now.")
            createTrainedCustomization()
            print("Adding a corpus to the trained customization.")
            addCorpusToTrainedCustomization()
            print("Training the customization with the corpus.")
            trainCustomizationWithCorpus()
        } else {
            guard let customizationStatus = customizationStatus else {
                XCTFail("Failed to obtain the status of the trained customization status.")
                return
            }
            
            switch customizationStatus {
            case .available, .ready:
                break // do nothing, because the customization is trained
            case .pending: // train -> then fail (wait for training)
                print("Training the `trained customization` used for tests.")
                self.trainCustomizationWithCorpus()
                print("The customization has been trained and is ready for use.")
            case .training: // fail (wait for training)
                let message = "Please wait a few minutes for the trained customization to finish " +
                "training. You can try running the tests again afterwards."
                XCTFail(message)
                return
            case .failed: // training failed => delete & retry
                let message = "Creating a trained ranker has failed. Check the errors " +
                "within the corpus and customization and retry."
                XCTFail(message)
                return
            }
        }
    }
    
    func createTrainedCustomization() {
        let failToCreateCustomization =  { (error: Error) in
            XCTFail("Failed to create the new customization: \(error)")
            return
        }
        
        let description = "Create a new customization."
        let expectation = self.expectation(description: description)
        speechToText.createCustomization(
            withName: self.trainedCustomizationName,
            withBaseModelName: "en-US_BroadbandModel",
            description: self.trainedCustomizationDescription,
            failure: failToCreateCustomization) { customization in
                
            self.trainedCustomizationID = customization.customizationID
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func addCorpusToTrainedCustomization() {
        
        let failToCreateCorpus =  { (error: Error) in
            XCTFail("Failed to create the new corpus: \(error)")
            return
        }
        
        guard let corpusFile = loadFile(name: "healthcare", withExtension: "txt") else {
            XCTFail("Failed to load file needed to create the corpus.")
            return
        }
        
        let description = "Add a corpus for the customization."
        let expectation = self.expectation(description: description)
        speechToText.addCorpus(
            withName: corpusName,
            fromFile: corpusFile,
            customizationID: self.trainedCustomizationID,
            failure: failToCreateCorpus) {
                
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func trainCustomizationWithCorpus() {
        
        let failToGetCorpusStatus = { (error: Error) in
            XCTFail("Failed to get the status of the new corpus: \(error)")
            return
        }
        
        let failToTrainCustomization = { (error: Error) in
            XCTFail("Failed to train the new customization: \(error)")
            return
        }
        
        let failToGetCustomizationStatus = { (error: Error) in
            XCTFail("Failed to get the status of the new customization: \(error)")
            return
        }
        
        var processed = false
        var tries = 0
        repeat {
            tries += 1
            let description = "Wait until the corpus is processed before training the customization."
            let expectation = self.expectation(description: description)
            
            speechToText.getCorpus(
                withName: corpusName,
                customizationID: self.trainedCustomizationID,
                failure: failToGetCorpusStatus) { corpus in
                    
                    if corpus.status == .analyzed {
                        processed = true
                    } else if corpus.status == .undetermined {
                        let message = "There was an error when processing the corpus, please check " +
                            "and fix the errors before trying again."
                        XCTFail(message)
                    }
                    expectation.fulfill()
            }
            waitForExpectations()
            
            if tries > 10 {
                XCTFail("The corpus is taking too long to process. Please try again later.")
            }
            
            sleep(3)
        } while(!processed)
        
        let description2 = "Train the customization with the new corpus."
        let expectation2 = self.expectation(description: description2)
        speechToText.trainCustomization(
            withID: self.trainedCustomizationID,
            failure: failToTrainCustomization) {
                
            expectation2.fulfill()
        }
        waitForExpectations()
        
        var trained = false
        tries = 0
        repeat {
            tries += 1
            let description3 = "Wait until the customization is trained."
            let expectation3 = self.expectation(description: description3)
            
            speechToText.getCustomization(
                withID: self.trainedCustomizationID,
                failure: failToGetCustomizationStatus) { customization in
                
                if customization.status == .available {
                    trained = true
                } else if customization.status == .failed {
                    let message = "There was an error when training the customization, please " +
                    "check and fix the errors before trying again."
                    XCTFail(message)
                }
                expectation3.fulfill()
            }
            waitForExpectations()
            
            if tries > 10 {
                XCTFail("The customization is taking too long to train. Please try again later.")
            }
            
            sleep(3)
        } while(!trained)
    }
    
    // MARK: - Models
    
    func testModels() {
        let description1 = "Get information about all models."
        let expectation1 = expectation(description: description1)
        
        var allModels = [Model]()
        speechToText.getModels(failure: failWithError) { models in
            allModels = models
            expectation1.fulfill()
        }
        waitForExpectations()
        
        for model in allModels {
            let description2 = "Get information about a particular model."
            let expectation2 = expectation(description: description2)
            speechToText.getModel(withID: model.name) { newModel in
                XCTAssertEqual(model.name, newModel.name)
                XCTAssertEqual(model.rate, newModel.rate)
                XCTAssertEqual(model.language, newModel.language)
                XCTAssertEqual(model.url, newModel.url)
                XCTAssertEqual(model.description, newModel.description)
                expectation2.fulfill()
            }
            waitForExpectations()
        }
    }
    
    // MARK: - Custom model
    
    func testTranscribeWithCustomModel() {
        let description = "Transcribe an audio file using custom model."
        let expectation = self.expectation(description: description)
        
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: "SpeechSample", withExtension: "wav") else {
            XCTFail("Unable to locate SpeechSample.wav.")
            return
        }
        
        let settings = RecognitionSettings(contentType: .wav)
        speechToText.recognize(
            audio: file,
            settings: settings,
            model: "en-US_BroadbandModel",
            customizationID: trainedCustomizationID,
            failure: failWithError)
        {
            results in
            self.validateSTTResults(results: results.results, settings: settings)
            XCTAssertEqual(results.results.count, 1)
            XCTAssert(results.results.last?.final == true)
            let transcript = results.results.last?.alternatives.last?.transcript
            XCTAssertNotNil(transcript)
            XCTAssertGreaterThan(transcript!.characters.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetAllCustomModels() {
        let description = "Retrieve a list of custom language models associated with this account."
        let expectation = self.expectation(description: description)
        
        speechToText.getCustomizations(failure: failWithError) { customizations in
            XCTAssertGreaterThanOrEqual(customizations.count, 1)
            
            for customization in customizations {
                XCTAssertNotNil(customization.customizationID)
                XCTAssertNotNil(customization.created)
                XCTAssertNotNil(customization.language)
                XCTAssertNotNil(customization.dialect)
                XCTAssertNotNil(customization.owner)
                XCTAssertNotNil(customization.name)
                XCTAssertNotNil(customization.baseModelName)
                XCTAssertNotNil(customization.status)
                XCTAssertNotNil(customization.progress)
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateAndDeleteCustomModel() {
        let description = "Create a new customization."
        let expectation = self.expectation(description: description)
        
        var newCustomizationID: String?
        
        speechToText.createCustomization(
            withName: "swift-sdk-unit-test-customization-to-delete",
            withBaseModelName: "en-US_BroadbandModel",
            dialect: "en-US",
            description: "customization created for test",
            failure: failWithError) { customization in
            
            XCTAssertNotNil(customization.customizationID)
            newCustomizationID = customization.customizationID
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete the new customization."
        let expectation2 = self.expectation(description: description2)
        
        guard let customizationToDelete = newCustomizationID else {
            XCTFail("Failed to instantiate customizationID when creating customization.")
            return
        }
        
        speechToText.deleteCustomization(withID: customizationToDelete, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testListTrainedCustomModelDetails() {
        let description = "List details of the trained custom model."
        let expectation = self.expectation(description: description)
        
        speechToText.getCustomization(withID: trainedCustomizationID, failure: failWithError) {
            customization in
            
            XCTAssertEqual(customization.customizationID, self.trainedCustomizationID)
            XCTAssertNotNil(customization.created)
            XCTAssertEqual(customization.language, "en-US")
            XCTAssertNotNil(customization.owner)
            XCTAssertEqual(customization.name, self.trainedCustomizationName)
            XCTAssertEqual(customization.baseModelName, "en-US_BroadbandModel")
            XCTAssertEqual(customization.description, self.trainedCustomizationDescription)
            XCTAssertNotNil(customization.status)
            XCTAssertNotNil(customization.progress)
            XCTAssertNil(customization.warnings)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Custom corpora
    
    func testGetAllCorpora() {
        let description = "List all corpora for the trained custom model."
        let expectation = self.expectation(description: description)
        
        speechToText.getCorpora(customizationID: trainedCustomizationID, failure: failWithError) {
            corpora in
            
            XCTAssertGreaterThanOrEqual(corpora.count, 1)
            for corpus in corpora {
                XCTAssertNotNil(corpus.name)
                XCTAssertNotNil(corpus.status)
                XCTAssertNotNil(corpus.totalWords)
                XCTAssertNotNil(corpus.outOfVocabularyWords)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCreateAndDeleteCorpus() {
        let description = "Create a new corpus."
        let expectation = self.expectation(description: description)
        
        guard let corpusFile = loadFile(name: "healthcare-short", withExtension: "txt") else {
            XCTFail("Failed to load file needed to create the corpus.")
            return
        }

        let newCorpusName = "swift-sdk-unit-test-corpus-to-delete"

        speechToText.addCorpus(
            withName: newCorpusName,
            fromFile: corpusFile,
            customizationID: trainedCustomizationID,
            failure: failWithError) {
            
            expectation.fulfill()
        }
        waitForExpectations()
        
        var processed = false
        var tries = 0
        repeat {
            tries += 1
            let description2 = "Wait until the corpus is processed before deleting it."
            let expectation2 = self.expectation(description: description2)
            
            speechToText.getCorpus(
                withName: newCorpusName,
                customizationID: self.trainedCustomizationID,
                failure: failWithError) { corpus in
                    
                    if corpus.status == .analyzed {
                        processed = true
                    } else if corpus.status == .undetermined {
                        let message = "There was an error when processing the corpus, please check " +
                        "and fix the errors before trying again."
                        XCTFail(message)
                    }
                    expectation2.fulfill()
            }
            waitForExpectations()
            
            if tries > 10 {
                XCTFail("The corpus is taking too long to process. Please try again later.")
            }
            
            sleep(3)
        } while(!processed)
        
        let description3 = "Delete the new corpus."
        let expectation3 = self.expectation(description: description3)
        
        speechToText.deleteCorpus(
            withName: newCorpusName,
            customizationID: trainedCustomizationID,
            failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetCorpusForTrainedCustomization() {
        let description = "Get the corpus used to build the trained customization."
        let expectation = self.expectation(description: description)
        
        speechToText.getCorpus(
            withName: corpusName,
            customizationID: trainedCustomizationID,
            failure: failWithError) { corpus in
                
            XCTAssertEqual(corpus.name, self.corpusName)
            XCTAssertEqual(corpus.status, .analyzed)
            XCTAssertEqual(corpus.totalWords, 40286)
            XCTAssertEqual(corpus.outOfVocabularyWords, 286)
            XCTAssertNil(corpus.error)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Custom words
    
    func testGetAllWords() {
        let description = "Get all words of a custom model."
        let expectation = self.expectation(description: description)

        speechToText.getWords(customizationID: trainedCustomizationID, wordType: .all, failure: failWithError) {
            words in
            
            XCTAssertGreaterThanOrEqual(words.count, 1)
            for word in words {
                XCTAssertNotNil(word.word)
                XCTAssertNotNil(word.soundsLike)
                XCTAssertNotNil(word.displayAs)
                XCTAssertNotNil(word.count)
                XCTAssertNotNil(word.source)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testAddAndDeleteMultipleWords() {
        let description = "Add 2 words to the trained customization."
        let expectation = self.expectation(description: description)
        
        let word1 = NewWord(word: "HHonors", soundsLike: ["hilton honors", "h honors"], displayAs: "HHonors")
        let word2 = NewWord(word: "IEEE", soundsLike: ["i triple e"])
        speechToText.addWords(customizationID: trainedCustomizationID, words: [word1, word2], failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
        
        var ready = false
        var tries = 0
        repeat {
            tries += 1
            let description1 = "Wait until the customization is ready before deleting the new words."
            let expectation1 = self.expectation(description: description1)
            
            speechToText.getCustomization(withID: trainedCustomizationID, failure: failWithError) {
                customization in
                
                if customization.status == .ready {
                    ready = true
                } else if customization.status == .failed {
                    let message = "The customization has failed, please fix the errors and try " +
                        "again later."
                    XCTFail(message)
                }
                expectation1.fulfill()
            }
            waitForExpectations()
            
            if tries > 10 {
                XCTFail("Customization is not ready. Please try again later.")
            }
            
            sleep(3)
        } while(!ready)
        
        let description2 = "Delete word1."
        let expectation2 = self.expectation(description: description2)
        
        speechToText.deleteWord(withName: word1.word!, customizationID: trainedCustomizationID, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Delete word2."
        let expectation3 = self.expectation(description: description3)
        
        speechToText.deleteWord(withName: word2.word!, customizationID: trainedCustomizationID, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()
    }
    
    func testAddAndDeleteASingleWord() {
        let description = "Add 1 word to the trained customization."
        let expectation = self.expectation(description: description)
        
        let word1 = NewWord(soundsLike: ["hilton honors", "h honors"], displayAs: "HHonors")
        speechToText.addWord(withName: "HHonors", customizationID: trainedCustomizationID, word: word1, failure: failWithError) {
            expectation.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Delete word1."
        let expectation2 = self.expectation(description: description2)
        
        speechToText.deleteWord(withName: "HHonors", customizationID: trainedCustomizationID, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()
    }
    
    func testGetWord() {
        let description = "Get a specific word."
        let expectation = self.expectation(description: description)
        
        speechToText.getWord(
            withName: "hyperventilation",
            customizationID: trainedCustomizationID,
            failure: failWithError) { word in
            
            XCTAssertEqual(word.word, "hyperventilation")
            XCTAssertEqual(word.soundsLike, ["hyperventilation"])
            XCTAssertEqual(word.displayAs, "hyperventilation")
            XCTAssertEqual(word.count, 1)
            XCTAssertEqual(word.source, [self.corpusName])
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Token Authentication
    
    func testInvalidCredentials() {
        let description = "Test invalid credentials."
        let expectation = self.expectation(description: description)
        
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: "SpeechSample", withExtension: "wav") else {
            XCTFail("Unable to locate SpeechSample.wav.")
            return
        }
        
        let speechToText = SpeechToText(username: "invalid", password: "invalid")
        let settings = RecognitionSettings(contentType: .wav)
        let failure = { (error: Error) in
            if error.localizedDescription.contains("Please confirm that your credentials match") {
                expectation.fulfill()
            }
        }
        
        speechToText.recognize(audio: file, settings: settings, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    // MARK: - Transcribe File, Default Settings

    func testTranscribeFileDefaultWAV() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "wav", format: .wav)
    }

    func testTranscribeFileDefaultOpus() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "ogg", format: .oggOpus)
    }

    func testTranscribeFileDefaultFLAC() {
        transcribeFileDefault(filename: "SpeechSample", withExtension: "flac", format: .flac)
    }

    func transcribeFileDefault(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        let settings = RecognitionSettings(contentType: format)
        speechToText.recognize(audio: file, settings: settings, failure: failWithError) { results in
            self.validateSTTResults(results: results.results, settings: settings)
            XCTAssertEqual(results.results.count, 1)
            XCTAssert(results.results.last?.final == true)
            let transcript = results.results.last?.alternatives.last?.transcript
            XCTAssertNotNil(transcript)
            XCTAssertGreaterThan(transcript!.characters.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Transcribe File, Custom Settings

    func testTranscribeFileCustomWAV() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "wav", format: .wav)
    }

    func testTranscribeFileCustomOpus() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "ogg", format: .oggOpus)
    }

    func testTranscribeFileCustomFLAC() {
        transcribeFileCustom(filename: "SpeechSample", withExtension: "flac", format: .flac)
    }

    func transcribeFileCustom(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        var settings = RecognitionSettings(contentType: format)
        settings.inactivityTimeout = -1
        settings.keywords = ["tornadoes"]
        settings.keywordsThreshold = 0.75
        settings.maxAlternatives = 3
        settings.interimResults = true
        settings.wordAlternativesThreshold = 0.25
        settings.wordConfidence = true
        settings.timestamps = true
        settings.filterProfanity = false
        settings.smartFormatting = true

        speechToText.recognize(audio: file, settings: settings, model: "en-US_BroadbandModel", learningOptOut: true, failure: failWithError) { results in
            self.validateSTTResults(results: results.results, settings: settings)
            if results.results.last?.final == true {
                let transcript = results.results.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.characters.count, 0)
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }

    // MARK: - Transcribe Data, Default Settings

    func testTranscribeDataDefaultWAV() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "wav", format: .wav)
    }

    func testTranscribeDataDefaultOpus() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "ogg", format: .oggOpus)
    }

    func testTranscribeDataDefaultFLAC() {
        transcribeDataDefault(filename: "SpeechSample", withExtension: "flac", format: .flac)
    }

    func transcribeDataDefault(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }
        
        do {
            let audio = try Data(contentsOf: file)
            
            let settings = RecognitionSettings(contentType: format)
            speechToText.recognize(audio: audio, settings: settings, failure: failWithError) { results in
                self.validateSTTResults(results: results.results, settings: settings)
                XCTAssertEqual(results.results.count, 1)
                XCTAssert(results.results.last?.final == true)
                let transcript = results.results.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.characters.count, 0)
                expectation.fulfill()
            }
            waitForExpectations()
        } catch {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }
    }

    // MARK: - Transcribe Data, Custom Settings

    func testTranscribeDataCustomWAV() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "wav", format: .wav)
    }

    func testTranscribeDataCustomOpus() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "ogg", format: .oggOpus)
    }

    func testTranscribeDataCustomFLAC() {
        transcribeDataCustom(filename: "SpeechSample", withExtension: "flac", format: .flac)
    }

    func transcribeDataCustom(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)

        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }
        
        do {
            let audio = try Data(contentsOf: file)
            
            var settings = RecognitionSettings(contentType: format)
            settings.inactivityTimeout = -1
            settings.keywords = ["tornadoes"]
            settings.keywordsThreshold = 0.75
            settings.maxAlternatives = 3
            settings.interimResults = true
            settings.wordAlternativesThreshold = 0.25
            settings.wordConfidence = true
            settings.timestamps = true
            settings.filterProfanity = false
            settings.smartFormatting = true
            
            speechToText.recognize(audio: audio, settings: settings, model: "en-US_BroadbandModel", learningOptOut: true, failure: failWithError) { results in
                self.validateSTTResults(results: results.results, settings: settings)
                if results.results.last?.final == true {
                    let transcript = results.results.last?.alternatives.last?.transcript
                    XCTAssertNotNil(transcript)
                    XCTAssertGreaterThan(transcript!.characters.count, 0)
                    expectation.fulfill()
                }
            }
            waitForExpectations()
        } catch {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }
    }
    
    // MARK: - Transcribe Data with Smart Formatting
    
    func testTranscribeStockAnnouncementCustomWAV() {
        transcribeDataCustomForNumbers(
            filename: "StockAnnouncement",
            withExtension: "wav",
            format: .wav,
            substring: "$152.37"
        )
    }
    
    func transcribeDataCustomForNumbers(
        filename: String,
        withExtension: String,
        format: AudioMediaType,
        substring: String)
    {
        let description = "Transcribe an audio file with smart formatting."
        let expectation = self.expectation(description: description)
        
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }
        
        guard let audio = try? Data(contentsOf: file) else {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }
        
        var settings = RecognitionSettings(contentType: format)
        settings.smartFormatting = true
        
        speechToText.recognize(audio: audio, settings: settings, model: "en-US_BroadbandModel", learningOptOut: true, failure: failWithError) { results in
            self.validateSTTResults(results: results.results, settings: settings)
            if results.results.last?.final == true {
                let transcript = results.results.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.characters.count, 0)
                XCTAssertTrue(transcript!.contains(substring))
                expectation.fulfill()
            }
        }
        waitForExpectations()
    }
    
    func testTranscribeDataWithSpeakerLabelsWAV() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "wav", format: .wav)
    }
    
    func testTranscribeDataWithSpeakerLabelsOpus() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "ogg", format: .oggOpus)
    }
    
    func testTranscribeDataWithSpeakerLabelsFLAC() {
        transcribeDataWithSpeakerLabels(filename: "SpeechSample", withExtension: "flac", format: .flac)
    }
    
    func transcribeDataWithSpeakerLabels(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
        let description = "Transcribe an audio file."
        let expectation = self.expectation(description: description)
        
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.url(forResource: filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }
        
        do {
            let audio = try Data(contentsOf: file)
            
            var settings = RecognitionSettings(contentType: format)
            settings.inactivityTimeout = -1
            settings.interimResults = false
            settings.wordConfidence = true
            settings.timestamps = true
            settings.filterProfanity = false
            settings.speakerLabels = true
            
            speechToText.recognize(audio: audio, settings: settings, model: "en-US_NarrowbandModel", learningOptOut: true, failure: failWithError) { results in
                self.validateSTTSpeakerLabels(speakerLabels: results.speakerLabels)
                expectation.fulfill()
            }
            waitForExpectations()
        } catch {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }
    }


    // MARK: - Transcribe Streaming

    func testTranscribeStreaming() {
        print("")
        print("******************************************************************************")
        print(" WARNING: Cannot test streaming audio in simulator.")
        print(" No audio capture devices are available. Please manually load the test")
        print(" application for streaming audio and run it on a physical device.")
        print("******************************************************************************")
        print("")
    }

    // MARK: - Validation Functions

    func validateSTTResults(results: [SpeechRecognitionResult], settings: RecognitionSettings) {
        for result in results {
            validateSTTResult(result: result, settings: settings)
        }
    }

    func validateSTTResult(result: SpeechRecognitionResult, settings: RecognitionSettings) {

        XCTAssertNotNil(result.final)
        let final = result.final

        XCTAssertNotNil(result.alternatives)
        var alternativesWithConfidence = 0
        for alternative in result.alternatives {
            if alternative.confidence != nil {
                alternativesWithConfidence += 1
                validateSTTTranscription(transcription: alternative, best: true, final: final, settings: settings)
            } else {
                validateSTTTranscription(transcription: alternative, best: false, final: final, settings: settings)
            }
        }

        if final {
            XCTAssertEqual(alternativesWithConfidence, 1)
        }

        if settings.keywords != nil, settings.keywords!.count > 0 && final {
            XCTAssertNotNil(settings.keywordsThreshold)
            XCTAssertGreaterThanOrEqual(settings.keywordsThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.keywordsThreshold!, 1.0)
            XCTAssertNotNil(result.keywordResults)
            XCTAssertGreaterThan(result.keywordResults!.count, 0)
            for (keyword, keywordResults) in result.keywordResults! {
                validateSTTKeywordResults(keyword: keyword, keywordResults: keywordResults)
            }
        } else {
            let isEmpty = (result.keywordResults?.count == 0)
            let isNil = (result.keywordResults == nil)
            XCTAssert(isEmpty || isNil)
        }

        if settings.wordAlternativesThreshold != nil && final {
            XCTAssertNotNil(settings.wordAlternativesThreshold)
            XCTAssertGreaterThanOrEqual(settings.wordAlternativesThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.wordAlternativesThreshold!, 1.0)
            XCTAssertNotNil(result.wordAlternatives)
            XCTAssertGreaterThan(result.wordAlternatives!.count, 0)
            for wordAlternatives in result.wordAlternatives! {
                validateSTTWordAlternativeResults(wordAlternatives: wordAlternatives)
            }
        } else {
            let isEmpty = (result.wordAlternatives?.count == 0)
            let isNil = (result.keywordResults == nil)
            XCTAssert(isEmpty || isNil)
        }
    }

    func validateSTTTranscription(
        transcription: SpeechRecognitionAlternative,
        best: Bool,
        final: Bool,
        settings: RecognitionSettings)
    {
        XCTAssertNotNil(transcription.transcript)
        XCTAssertGreaterThan(transcription.transcript.characters.count, 0)

        if best && final {
            XCTAssertNotNil(transcription.confidence)
            XCTAssertGreaterThanOrEqual(transcription.confidence!, 0.0)
            XCTAssertLessThanOrEqual(transcription.confidence!, 1.0)
        } else {
            XCTAssertNil(transcription.confidence)
        }

        if settings.timestamps == true && (!final || best) {
            XCTAssertNotNil(transcription.timestamps)
            XCTAssertGreaterThan(transcription.timestamps!.count, 0)
            for timestamp in transcription.timestamps! {
                validateSTTWordTimestamp(timestamp: timestamp)
            }
        } else {
            let isEmpty = (transcription.timestamps?.count == 0)
            let isNil = (transcription.timestamps == nil)
            XCTAssert(isEmpty || isNil)
        }

        if settings.wordConfidence == true && final && best {
            XCTAssertNotNil(transcription.wordConfidence)
            XCTAssertGreaterThan(transcription.wordConfidence!.count, 0)
            for word in transcription.wordConfidence! {
                validateSTTWordConfidence(word: word)
            }
        } else {
            let isEmpty = (transcription.wordConfidence?.count == 0)
            let isNil = (transcription.wordConfidence == nil)
            XCTAssert(isEmpty || isNil)
        }
    }

    func validateSTTWordTimestamp(timestamp: WordTimestamp) {
        XCTAssertGreaterThan(timestamp.word.characters.count, 0)
        XCTAssertGreaterThanOrEqual(timestamp.startTime, 0.0)
        XCTAssertGreaterThanOrEqual(timestamp.endTime, timestamp.startTime)
    }

    func validateSTTWordConfidence(word: WordConfidence) {
        XCTAssertGreaterThan(word.word.characters.count, 0)
        XCTAssertGreaterThanOrEqual(word.confidence, 0.0)
        XCTAssertLessThanOrEqual(word.confidence, 1.0)
    }

    func validateSTTKeywordResults(keyword: String, keywordResults: [KeywordResult]) {
        XCTAssertGreaterThan(keyword.characters.count, 0)
        XCTAssertGreaterThan(keywordResults.count, 0)
        for keywordResult in keywordResults {
            validateSTTKeywordResult(keywordResult: keywordResult)
        }
    }

    func validateSTTKeywordResult(keywordResult: KeywordResult) {
        XCTAssertGreaterThan(keywordResult.normalizedText.characters.count, 0)
        XCTAssertGreaterThanOrEqual(keywordResult.startTime, 0)
        XCTAssertGreaterThanOrEqual(keywordResult.endTime, keywordResult.startTime)
        XCTAssertGreaterThanOrEqual(keywordResult.confidence, 0.0)
        XCTAssertLessThanOrEqual(keywordResult.confidence, 1.0)
    }

    func validateSTTWordAlternativeResults(wordAlternatives: WordAlternativeResults) {
        XCTAssertGreaterThanOrEqual(wordAlternatives.startTime, 0.0)
        XCTAssertGreaterThanOrEqual(wordAlternatives.endTime, wordAlternatives.startTime)
        XCTAssertGreaterThan(wordAlternatives.alternatives.count, 0)
        for wordAlternative in wordAlternatives.alternatives {
            validateSTTWordAlternativeResult(wordAlternative: wordAlternative)
        }
    }

    func validateSTTWordAlternativeResult(wordAlternative: WordAlternativeResult) {
        XCTAssertGreaterThanOrEqual(wordAlternative.confidence, 0.0)
        XCTAssertLessThanOrEqual(wordAlternative.confidence, 1.0)
        XCTAssertGreaterThan(wordAlternative.word.characters.count, 0)
    }
    
    func validateSTTSpeakerLabels(speakerLabels: [SpeakerLabel]) {
        for speakerLabel in speakerLabels {
            validateSTTSpeakerLabel(speakerLabel: speakerLabel)
        }
    }
    
    func validateSTTSpeakerLabel(speakerLabel: SpeakerLabel) {
        XCTAssertGreaterThanOrEqual(speakerLabel.fromTime, 0)
        XCTAssertGreaterThanOrEqual(speakerLabel.toTime, 0)
        XCTAssertGreaterThanOrEqual(speakerLabel.confidence, 0.0)
        XCTAssertLessThanOrEqual(speakerLabel.confidence, 1.0)
        XCTAssertGreaterThanOrEqual(speakerLabel.speaker, 0)
    }

}
