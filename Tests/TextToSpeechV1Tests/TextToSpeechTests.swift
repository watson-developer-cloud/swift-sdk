/**
 * (C) Copyright IBM Corp. 2016, 2020.
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
import TextToSpeechV1

class TextToSpeechTests: XCTestCase {

    private var textToSpeech: TextToSpeech!
    private var customizationID: String!
    private let text = "Swift at IBM is awesome. You should try it!"
    private let allVoices = [
        "en-US_AllisonVoice",
        "en-US_LisaVoice",
        "en-US_MichaelVoice",
        "en-GB_KateVoice",
        "es-ES_EnriqueVoice",
        "es-ES_LauraVoice",
        "es-LA_SofiaVoice",
        "es-US_SofiaVoice",
        "de-DE_DieterVoice",
        "de-DE_BirgitVoice",
        "fr-FR_ReneeVoice",
        "it-IT_FrancescaVoice",
        "ja-JP_EmiVoice",
        "pt-BR_IsabelaVoice",
    ]
    private let litePlanMessage = "This feature is not available for the IBM Cloud Lite plan."

    static var allTests: [(String, (TextToSpeechTests) -> () throws -> Void)] {
        return [
            ("testListVoices", testListVoices),
            ("testGetVoice", testGetVoice),
            ("testGetPronunciation", testGetPronunciation),
            ("testSynthesizeOpus", testSynthesizeOpus),
            ("testSynthesizeWAV", testSynthesizeWAV),
            ("testSynthesizeFLAC", testSynthesizeFLAC),
            ("testSynthesizeL16", testSynthesizeL16),
            ("testListVoiceModels", testListVoiceModels),
            ("testVoiceModelsCRUD", testVoiceModelsCRUD),
            ("testWordsCRUD", testWordsCRUD),
            ("testGetPronunciationWithUndefinedVoice", testGetPronunciationWithUndefinedVoice),
            ("testGetVoiceInvalid", testGetVoiceInvalid),
            ("testSynthesizeEmptyString", testSynthesizeEmptyString),
            ("testSynthesizeWithInvalidVoice", testSynthesizeWithInvalidVoice),
            ("testGetCustomizationsWithInvalidLanguage", testGetCustomizationsWithInvalidLanguage),
            ("testCreateCustomizationWithInvalidLanguage", testCreateCustomizationWithInvalidLanguage),
            ("testDeleteCustomizationWithBadID", testDeleteCustomizationWithBadID),
            ("testGetCustomizationWithBadID", testGetCustomizationWithBadID),
            ("testUpdateCustomizationWithBadID", testUpdateCustomizationWithBadID),
            ("testGetWordsWithBadIDs", testGetWordsWithBadIDs),
            ("testAddMultipleWordsWithBadIDs", testAddMultipleWordsWithBadIDs),
            ("testDeleteWordWithBadIDs", testDeleteWordWithBadIDs),
            ("testGetWordWithBadIDs", testGetWordWithBadIDs),
            ("testAddWordWithBadIDs", testAddWordWithBadIDs),
            ("testCustomPromptsCRUD", testCustomPromptsCRUD),
            ("testSpeakerModelsCRUD", testSpeakerModelsCRUD),
        ]
    }

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
        deleteCustomizations()
        createCustomization()
    }

    /** Instantiate Text to Speech instance. */
    func instantiateTextToSpeech() {
        let authenticator = WatsonIAMAuthenticator.init(apiKey: WatsonCredentials.TextToSpeechAPIKey)
        textToSpeech = TextToSpeech(authenticator: authenticator)

        if let url = WatsonCredentials.TextToSpeechURL {
            textToSpeech.serviceURL = url
        }
        textToSpeech.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        textToSpeech.defaultHeaders["X-Watson-Test"] = "true"
    }
    
    /**Create customization. */
    func createCustomization() {
        let expectation = self.expectation(description: "Create custom model")
        
        textToSpeech.createCustomModel(name: "Swift SDK Test Custom Voice Model") {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssert(!result.customizationID.isEmpty)
            self.customizationID = result.customizationID
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Delete all customizations. */
    func deleteCustomizations() {
        let description = "Delete all customizations."
        let expectation = self.expectation(description: description)
        textToSpeech.listCustomModels {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
                return
            }
            guard let voiceModels = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            for voiceModel in voiceModels.customizations {
                self.textToSpeech.deleteCustomModel(customizationID: voiceModel.customizationID) { _, _ in }
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    func testListVoices() {
        let expectation = self.expectation(description: "List voices")
        textToSpeech.listVoices {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
                return
            }
            guard let voiceModels = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThanOrEqual(voiceModels.voices.count, self.allVoices.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetVoice() {
        for voice in allVoices {
            let expectation = self.expectation(description: "Get voice")
            textToSpeech.getVoice(voice: voice) {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let result = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertEqual(result.name, voice)
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }

    func testGetPronunciation() {
        for voice in allVoices {
            let expectation = self.expectation(description: "Get pronunciation")
            if voice == "ja-JP_EmiVoice" { expectation.fulfill(); continue }
            textToSpeech.getPronunciation(text: text, voice: voice, format: "ibm") {
                response, error in
                if let error = error {
                    XCTFail(unexpectedErrorMessage(error))
                    return
                }
                guard let pronunciation = response?.result else {
                    XCTFail(missingResultMessage)
                    return
                }
                XCTAssertGreaterThan(pronunciation.pronunciation.count, 0)
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }

    func testSynthesizeOpus() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/ogg;codecs=opus") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeWAV() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/wav") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeFLAC() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/flac") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeL16() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/l16;rate=44100") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let data = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListVoiceModels() {
        let expectation = self.expectation(description: "List voice models")
        textToSpeech.listCustomModels {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation.fulfill()
                return
            }
            guard let voiceModels = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(voiceModels.customizations.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testVoiceModelsCRUD() {
        let expectation1 = self.expectation(description: "Create voice model")
        let name = "Swift SDK Test Custom Voice Model"
        var voiceModel: CustomModel!
        textToSpeech.createCustomModel(name: name) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation1.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssert(!result.customizationID.isEmpty)
            voiceModel = result
            expectation1.fulfill()
        }
        waitForExpectations()

        // If the create request failed, skip the rest of the test.
        guard voiceModel != nil else {
            return
        }

        let expectation2 = self.expectation(description: "Get voice model")
        let customizationID = voiceModel.customizationID
        textToSpeech.getCustomModel(customizationID: customizationID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(result.customizationID, voiceModel.customizationID)
            XCTAssertEqual(result.name, name)
            expectation2.fulfill()
        }
        waitForExpectations()

        let expectation3 = self.expectation(description: "Update voice model")
        let newName = name + " - Updated"
        let description = "Safe to delete"
        let words = [Word(word: "IBM", translation: "eye bee em"), Word(word: "MIL", translation: "mill")]
        textToSpeech.updateCustomModel(customizationID: customizationID, name: newName, description: description, words: words) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation3.fulfill()
        }
        waitForExpectations()

        let expectation4 = self.expectation(description: "Get voice model")
        textToSpeech.getCustomModel(customizationID: customizationID) {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(result.customizationID, voiceModel.customizationID)
            XCTAssertEqual(result.name, newName)
            XCTAssertEqual(result.description, description)
            XCTAssertNotNil(result.words)
            XCTAssertEqual(result.words!.count, 2)
            XCTAssert(result.words!.contains { $0.word == "IBM" })
            XCTAssert(result.words!.contains { $0.word == "MIL" })
            expectation4.fulfill()
        }
        waitForExpectations()

        let expectation5 = self.expectation(description: "Delete voice model")
        textToSpeech.deleteCustomModel(customizationID: customizationID) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation5.fulfill()
        }
        waitForExpectations()
    }

    func testWordsCRUD() {
        let expectation1 = self.expectation(description: "Create voice model")
        var voiceModel: CustomModel!
        textToSpeech.createCustomModel(name: "Swift SDK Test Custom Voice Model") {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation1.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssert(!result.customizationID.isEmpty)
            voiceModel = result
            expectation1.fulfill()
        }
        waitForExpectations()

        // If the create request failed, skip the rest of the test.
        guard voiceModel != nil else {
            return
        }

        let expectation2 = self.expectation(description: "Add words")
        let customizationID = voiceModel.customizationID
        let words = [Word(word: "IBM", translation: "eye bee em")]
        textToSpeech.addWords(customizationID: customizationID, words: words) {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation2.fulfill()
        }
        waitForExpectations()

        let expectation3 = self.expectation(description: "Add word")
        textToSpeech.addWord(customizationID: customizationID, word: "MIL", translation: "mill") {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation3.fulfill()
        }
        waitForExpectations()

        let expectation4 = self.expectation(description: "List words")
        textToSpeech.listWords(customizationID: customizationID) {
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
            XCTAssert(result.words.contains { $0.word == "IBM" })
            XCTAssert(result.words.contains { $0.word == "MIL" })
            expectation4.fulfill()
        }
        waitForExpectations()

        let expectation5 = self.expectation(description: "Get word")
        textToSpeech.getWord(customizationID: customizationID, word: "IBM") {
            response, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
                return
            }
            guard let translation = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(translation.translation, "eye bee em")
            expectation5.fulfill()
        }
        waitForExpectations()

        let expectation6 = self.expectation(description: "Delete word")
        textToSpeech.deleteWord(customizationID: customizationID, word: "MIL") {
            _, error in
            if let error = error {
                XCTFail(unexpectedErrorMessage(error))
            }
            expectation6.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testGetPronunciationWithUndefinedVoice() {
        let expectation = self.expectation(description: "Get pronunciation")
        let voice = "invalid-voice"
        textToSpeech.getPronunciation(text: text, voice: voice) {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetVoiceInvalid() {
        let expectation = self.expectation(description: "Get voice")
        let voice = "invalid-voice"
        textToSpeech.getVoice(voice: voice) {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeEmptyString() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: "") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeWithInvalidVoice() {
        let expectation = self.expectation(description: "Synthesize")
        let voice = "invalid-voice"
        textToSpeech.synthesize(text: text, voice: voice) {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetCustomizationsWithInvalidLanguage() {
        let expectation = self.expectation(description: "List voice models")
        textToSpeech.listCustomModels(language: "invalid-language") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testCreateCustomizationWithInvalidLanguage() {
        let expectation = self.expectation(description: "Create voice model")
        textToSpeech.createCustomModel(name: "custom-model", language: "invalid-language") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDeleteCustomizationWithBadID() {
        let expectation = self.expectation(description: "Delete voice model")
        textToSpeech.deleteCustomModel(customizationID: "invalid-id") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetCustomizationWithBadID() {
        let expectation = self.expectation(description: "Get voice model")
        textToSpeech.getCustomModel(customizationID: "invalid-id") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testUpdateCustomizationWithBadID() {
        let expectation = self.expectation(description: "Update voice model")
        textToSpeech.updateCustomModel(customizationID: "invalid-id") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetWordsWithBadIDs() {
        let expectation = self.expectation(description: "List words")
        textToSpeech.listWords(customizationID: "invalid-id") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testAddMultipleWordsWithBadIDs() {
        let expectation = self.expectation(description: "Add words")
        textToSpeech.addWords(customizationID: "invalid-id", words: []) {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testDeleteWordWithBadIDs() {
        let expectation = self.expectation(description: "Delete word")
        textToSpeech.deleteWord(customizationID: "invalid-id", word: "invalid-word") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetWordWithBadIDs() {
        let expectation = self.expectation(description: "Get word")
        textToSpeech.getWord(customizationID: "invalid-id", word: "invalid-word") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()

        }
        waitForExpectations()
    }

    func testAddWordWithBadIDs() {
        let expectation = self.expectation(description: "Add word")
        textToSpeech.addWord(customizationID: "invalid-id", word: "invalid-word", translation: "invalid-translation") {
            _, error in
            if error == nil {
                XCTFail(missingErrorMessage)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    func testCustomPromptsCRUD() {
        let promptID = "hello"
        
        //Create request
        let expectation1 = self.expectation(description: "Create custom prompt")
        var prompt: Prompt!
        let promptMetadata = PromptMetadata(promptText: "Hello, how are you today?")
        let file = Bundle(for: type(of: self)).url(forResource: "custom_prompt_audio", withExtension: "wav")!
        let fileData = try! Data(contentsOf: file)
        let filename = "custom_prompt_audio.wav"
        textToSpeech.addCustomPrompt(customizationID: customizationID, promptID: promptID, metadata: promptMetadata, file: fileData, filename: filename) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation1.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            prompt = result
            XCTAssert(!prompt.promptID.isEmpty)
            expectation1.fulfill()
        }
        waitForExpectations()

        // If the create request failed, skip the rest of the test.
        guard prompt != nil else {
            return
        }
        
        //List Request
        let expectation2 = self.expectation(description: "List custom prompts")
        textToSpeech.listCustomPrompts (customizationID: customizationID) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation2.fulfill()
                return
            }
            guard let prompts = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssert(!prompts.prompts.isEmpty)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        //Get Request
        let expectation3 = self.expectation(description: "Get custom prompts")
        textToSpeech.getCustomPrompt(customizationID: customizationID, promptID: promptID) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation3.fulfill()
                return
            }
            guard let prompt = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertEqual(prompt.promptID, promptID)
            expectation3.fulfill()
        }
        waitForExpectations()
        
        //Delete Request
        let expectation4 = self.expectation(description: "Delete custom prompts")
        textToSpeech.deleteCustomPrompt(customizationID: customizationID, promptID: promptID) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation4.fulfill()
                return
            }
            XCTAssertNotNil(response)
            expectation4.fulfill()
        }
        waitForExpectations()
        
    }
    
    func testSpeakerModelsCRUD() {
        var speakerID: String!
        
        //Create Request
        let expectation1 = self.expectation(description: "Create speaker models")
        var speakerModel: SpeakerModel!
        let file = Bundle(for: type(of: self)).url(forResource: "custom_prompt_audio", withExtension: "wav")!
        let fileData = try! Data(contentsOf: file)
        
        textToSpeech.createSpeakerModel(speakerName: "Angelo2", audio: fileData) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation1.fulfill()
                return
            }
            guard let result = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            
            speakerModel = result
            XCTAssert(!speakerModel.speakerID.isEmpty)
            speakerID = speakerModel.speakerID
            expectation1.fulfill()
        }
        waitForExpectations()
        
        // If the create request failed, skip the rest of the test.
        guard speakerModel != nil else {
            return
        }
        
        //List Request
        let expectation2 = self.expectation(description: "List speaker models")
        textToSpeech.listSpeakerModels() {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation2.fulfill()
                return
            }
            guard let speakerModels = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssert(!speakerModels.speakers.isEmpty)
            expectation2.fulfill()
        }
        waitForExpectations()
        
        //Get Request
        let expectation3 = self.expectation(description: "Get speaker model")
        textToSpeech.getSpeakerModel(speakerID: speakerID) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation3.fulfill()
                return
            }
            guard let speakerModel = response?.result else {
                XCTFail(missingResultMessage)
                return
            }
            XCTAssertNotNil(speakerModel)
            expectation3.fulfill()
        }
        waitForExpectations()
        
        //Delete Request
        let expectation4 = self.expectation(description: "Delete speaker model")
        textToSpeech.deleteSpeakerModel(speakerID: speakerID) {
            response, error in
            if let error = error {
                if !error.localizedDescription.contains(self.litePlanMessage) {
                    XCTFail(unexpectedErrorMessage(error))
                }
                expectation4.fulfill()
                return
            }
            XCTAssertNotNil(response)
            expectation4.fulfill()
        }
        waitForExpectations()
    }
}
