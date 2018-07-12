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
import TextToSpeechV1

class TextToSpeechTests: XCTestCase {

    private var textToSpeech: TextToSpeech!
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
    private let litePlanMessage = "This feature is not available for the Bluemix Lite plan."

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
        ]
    }

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
        deleteCustomizations()
    }

    /** Instantiate Text to Speech instance. */
    func instantiateTextToSpeech() {
        if let apiKey = WatsonCredentials.TextToSpeechAPIKey {
            textToSpeech = TextToSpeech(apiKey: apiKey)
        } else {
            let username = WatsonCredentials.TextToSpeechUsername
            let password = WatsonCredentials.TextToSpeechPassword
            textToSpeech = TextToSpeech(username: username, password: password)
        }
        if let url = WatsonCredentials.TextToSpeechURL {
            textToSpeech.serviceURL = url
        }
        textToSpeech.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        textToSpeech.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Delete all customizations. */
    func deleteCustomizations() {
        let description = "Delete all customizations."
        let expectation = self.expectation(description: description)
        textToSpeech.listVoiceModels(failure: failExceptLitePlan(expectation: expectation)) { voiceModels in
            for voiceModel in voiceModels.customizations {
                self.textToSpeech.deleteVoiceModel(customizationID: voiceModel.customizationID) { }
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

    /** Fail unless error is due to Lite Plan */
    func failExceptLitePlan(expectation: XCTestExpectation,
                            message: String = "Positive test failed with error") -> ((Error) -> Void) {
        return { (error: Error) in
            if !error.localizedDescription.contains(self.litePlanMessage) {
                XCTFail("\(message): \(error)")
            }
            expectation.fulfill()
        }
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 5.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    func testListVoices() {
        let expectation = self.expectation(description: "List voices")
        textToSpeech.listVoices(failure: failExceptLitePlan(expectation: expectation)) { response in
            XCTAssertGreaterThanOrEqual(response.voices.count, self.allVoices.count)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testGetVoice() {
        for voice in allVoices {
            let expectation = self.expectation(description: "Get voice")
            textToSpeech.getVoice(voice: voice, failure: failWithError) { response in
                XCTAssertEqual(response.name, voice)
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }

    func testGetPronunciation() {
        for voice in allVoices {
            let expectation = self.expectation(description: "Get pronunciation")
            if voice == "ja-JP_EmiVoice" { expectation.fulfill(); continue }
            textToSpeech.getPronunciation(text: text, voice: voice, format: "ibm", failure: failWithError) {
                pronunciation in
                XCTAssertGreaterThan(pronunciation.pronunciation.count, 0)
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }

    func testSynthesizeOpus() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/ogg;codecs=opus", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeWAV() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/wav", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeFLAC() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/flac", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testSynthesizeL16() {
        let expectation = self.expectation(description: "Synthesize")
        textToSpeech.synthesize(text: text, accept: "audio/l16;rate=44100", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testListVoiceModels() {
        let expectation = self.expectation(description: "List voice models")
        textToSpeech.listVoiceModels(failure: failExceptLitePlan(expectation: expectation)) { customizations in
            XCTAssertEqual(customizations.customizations.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    func testVoiceModelsCRUD() {
        let expectation1 = self.expectation(description: "Create voice model")
        let name = "Swift SDK Test Custom Voice Model"
        var voiceModel: VoiceModel!
        textToSpeech.createVoiceModel(name: name, failure: failExceptLitePlan(expectation: expectation1)) { response in
            XCTAssert(!response.customizationID.isEmpty)
            voiceModel = response
            expectation1.fulfill()
        }
        waitForExpectations()

        // If the create request failed, skip the rest of the test.
        guard voiceModel != nil else {
            return
        }

        let expectation2 = self.expectation(description: "Get voice model")
        let customizationID = voiceModel.customizationID
        textToSpeech.getVoiceModel(customizationID: customizationID, failure: failWithError) { response in
            XCTAssertEqual(response.customizationID, voiceModel.customizationID)
            XCTAssertEqual(response.name, name)
            expectation2.fulfill()
        }
        waitForExpectations()

        let expectation3 = self.expectation(description: "Update voice model")
        let newName = name + " - Updated"
        let description = "Safe to delete"
        let words = [Word(word: "IBM", translation: "eye bee em"), Word(word: "MIL", translation: "mill")]
        textToSpeech.updateVoiceModel(customizationID: customizationID, name: newName, description: description, words: words, failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()

        let expectation4 = self.expectation(description: "Get voice model")
        textToSpeech.getVoiceModel(customizationID: customizationID, failure: failWithError) { response in
            XCTAssertEqual(response.customizationID, voiceModel.customizationID)
            XCTAssertEqual(response.name, newName)
            XCTAssertEqual(response.description, description)
            XCTAssertNotNil(response.words)
            XCTAssertEqual(response.words!.count, 2)
            XCTAssert(response.words!.contains { $0.word == "IBM" })
            XCTAssert(response.words!.contains { $0.word == "MIL" })
            expectation4.fulfill()
        }
        waitForExpectations()

        let expectation5 = self.expectation(description: "Delete voice model")
        textToSpeech.deleteVoiceModel(customizationID: customizationID, failure: failWithError) {
            expectation5.fulfill()
        }
        waitForExpectations()
    }

    func testWordsCRUD() {
        let expectation1 = self.expectation(description: "Create voice model")
        var voiceModel: VoiceModel!
        textToSpeech.createVoiceModel(name: "Swift SDK Test Custom Voice Model",
                                      failure: failExceptLitePlan(expectation: expectation1)) { response in
            XCTAssert(!response.customizationID.isEmpty)
            voiceModel = response
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
        textToSpeech.addWords(customizationID: customizationID, words: words, failure: failWithError) {
            expectation2.fulfill()
        }
        waitForExpectations()

        let expectation3 = self.expectation(description: "Add word")
        textToSpeech.addWord(customizationID: customizationID, word: "MIL", translation: "mill", failure: failWithError) {
            expectation3.fulfill()
        }
        waitForExpectations()

        let expectation4 = self.expectation(description: "List words")
        textToSpeech.listWords(customizationID: customizationID, failure: failWithError) { response in
            XCTAssertEqual(response.words.count, 2)
            XCTAssert(response.words.contains { $0.word == "IBM" })
            XCTAssert(response.words.contains { $0.word == "MIL" })
            expectation4.fulfill()
        }
        waitForExpectations()

        let expectation5 = self.expectation(description: "Get word")
        textToSpeech.getWord(customizationID: customizationID, word: "IBM", failure: failWithError) { translation in
            XCTAssertEqual(translation.translation, "eye bee em")
            expectation5.fulfill()
        }
        waitForExpectations()

        let expectation6 = self.expectation(description: "Delete word")
        textToSpeech.deleteWord(customizationID: customizationID, word: "MIL", failure: failWithError) {
            expectation6.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testGetPronunciationWithUndefinedVoice() {
        let expectation = self.expectation(description: "Get pronunciation")
        let voice = "invalid-voice"
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.getPronunciation(text: text, voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetVoiceInvalid() {
        let expectation = self.expectation(description: "Get voice")
        let voice = "invalid-voice"
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.getVoice(voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testSynthesizeEmptyString() {
        let expectation = self.expectation(description: "Synthesize")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.synthesize(text: "", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testSynthesizeWithInvalidVoice() {
        let expectation = self.expectation(description: "Synthesize")
        let voice = "invalid-voice"
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.synthesize(text: text, voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetCustomizationsWithInvalidLanguage() {
        let expectation = self.expectation(description: "List voice models")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.listVoiceModels(language: "invalid-language", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testCreateCustomizationWithInvalidLanguage() {
        let expectation = self.expectation(description: "Create voice model")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.createVoiceModel(name: "custom-model", language: "invalid-language", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testDeleteCustomizationWithBadID() {
        let expectation = self.expectation(description: "Delete voice model")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.deleteVoiceModel(customizationID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetCustomizationWithBadID() {
        let expectation = self.expectation(description: "Get voice model")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.getVoiceModel(customizationID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testUpdateCustomizationWithBadID() {
        let expectation = self.expectation(description: "Update voice model")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.updateVoiceModel(customizationID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetWordsWithBadIDs() {
        let expectation = self.expectation(description: "List words")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.listWords(customizationID: "invalid-id", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testAddMultipleWordsWithBadIDs() {
        let expectation = self.expectation(description: "Add words")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.addWords(customizationID: "invalid-id", words: [], failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testDeleteWordWithBadIDs() {
        let expectation = self.expectation(description: "Delete word")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.deleteWord(customizationID: "invalid-id", word: "invalid-word", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testGetWordWithBadIDs() {
        let expectation = self.expectation(description: "Get word")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.getWord(customizationID: "invalid-id", word: "invalid-word", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    func testAddWordWithBadIDs() {
        let expectation = self.expectation(description: "Add word")
        let failure = { (error: Error) in expectation.fulfill() }
        textToSpeech.addWord(customizationID: "invalid-id", word: "invalid-word", translation: "invalid-translation", failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
