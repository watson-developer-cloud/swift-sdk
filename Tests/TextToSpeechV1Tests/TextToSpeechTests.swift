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

// swiftlint:disable function_body_length force_try force_unwrapping superfluous_disable_command

import XCTest
import Foundation
import TextToSpeechV1

class TextToSpeechTests: XCTestCase {

    private var textToSpeech: TextToSpeech!
    private let text = "Swift at IBM is awesome. You should try it!"

    private let allVoices: [SynthesisVoice] = [
        .de_Birgit, .de_Dieter, .gb_Kate, .es_Enrique, .us_Allison, .us_Lisa, .us_Michael,
        .es_Laura, .us_Sofia, .fr_Renee, .it_Francesca, .jp_Emi, .br_Isabela,
    ]

    static var allTests: [(String, (TextToSpeechTests) -> () throws -> Void)] {
        return [
            ("testGetVoices", testGetVoices),
            ("testGetVoice", testGetVoice),
            ("testGetPronunciation", testGetPronunciation),
            ("testSynthesizeOpus", testSynthesizeOpus),
            ("testSynthesizeWAV", testSynthesizeWAV),
            ("testSynthesizeFLAC", testSynthesizeFLAC),
            ("testSynthesizeL16", testSynthesizeL16),
            ("testGetCustomizations", testGetCustomizations),
            ("testCreateAndDeleteCustomization", testCreateAndDeleteCustomization),
            // ("testCreateUpdateNameAndDeleteCustomVoiceModel", testCreateUpdateNameAndDeleteCustomVoiceModel), // temporarily disabled
            // ("testCreateUpdateDescriptionAndDeleteCustomVoiceModel", testCreateUpdateDescriptionAndDeleteCustomVoiceModel), // temporarily disabled
            ("testCreateUpdateWordsListAndDeleteCustomVoiceModel", testCreateUpdateWordsListAndDeleteCustomVoiceModel),
            ("testAddMultipleWordsToCustomVoiceModel", testAddMultipleWordsToCustomVoiceModel),
            ("testAddOneWordToCustomVoiceModel", testAddOneWordToCustomVoiceModel),
            ("testAddAndDeleteOneWordToCustomVoiceModel", testAddAndDeleteOneWordToCustomVoiceModel),
            ("testGetPronunciationWithUndefinedVoice", testGetPronunciationWithUndefinedVoice),
            ("testGetVoiceInvalid", testGetVoiceInvalid),
            ("testSynthesizeEmptyString", testSynthesizeEmptyString),
            ("testSynthesizeWithInvalidVoice", testSynthesizeWithInvalidVoice),
            ("testGetCustomizationsWithInvalidLanguage", testGetCustomizationsWithInvalidLanguage),
            ("testCreateCustomizationWithInvalidLanguage", testCreateCustomizationWithInvalidLanguage),
            ("testDeleteCustomizationWithBadID", testDeleteCustomizationWithBadID),
            ("testDeleteCustomizationWithInaccessibleID", testDeleteCustomizationWithInaccessibleID),
            ("testGetCustomizationWithBadID", testGetCustomizationWithBadID),
            ("testGetCustomizationWithInaccessibleID", testGetCustomizationWithInaccessibleID),
            ("testUpdateCustomizationWithBadID", testUpdateCustomizationWithBadID),
            ("testUpdateCustomizationWithInaccessibleID", testUpdateCustomizationWithInaccessibleID),
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
        let username = Credentials.TextToSpeechUsername
        let password = Credentials.TextToSpeechPassword
        textToSpeech = TextToSpeech(username: username, password: password)
        textToSpeech.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        textToSpeech.defaultHeaders["X-Watson-Test"] = "true"
    }

    /** Delete all customizations. */
    func deleteCustomizations() {
        let description = "Delete all customizations."
        let expectation = self.expectation(description: description)

        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            for customization in customizations {
                self.textToSpeech.deleteCustomization(withID: customization.customizationID)
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
    func waitForExpectations(timeout: TimeInterval = 5.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    /** Retrieve all available voices. */
    func testGetVoices() {
        let description = "Retrieve information about all available voices."
        let expectation = self.expectation(description: description)

        textToSpeech.getVoices(failure: failWithError) { voices in
            XCTAssertGreaterThanOrEqual(voices.count, 8)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Retrieve information about each available voice. */
    func testGetVoice() {
        for voice in allVoices {
            let description = "Get information about the given voice."
            let expectation = self.expectation(description: description)
            textToSpeech.getVoice(voice.rawValue, failure: failWithError) { _ in
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }

    /** Get the phonetic pronunciation of the given text. */
    func testGetPronunciation() {
        for voice in allVoices {
            let description = "Get the phonetic pronunciation of the given text."
            let expectation = self.expectation(description: description)

            if case .jp_Emi = voice {
                expectation.fulfill()
                continue
            }

            textToSpeech.getPronunciation(of: text, voice: voice.rawValue, format: .spr, failure: failWithError) {
                pronunciation in
                XCTAssertGreaterThan(pronunciation.pronunciation.count, 0)
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }

    // This test works when you run it individually, but for some reason, running it after the
    // testSynthesizeFlac() method causes this one to fail. The audio types aren't updated somehow,
    // and the service seems to think we are still requesting .flac instead of .opus.
    /** Synthesize text to spoken audio in Opus format. */
    func testSynthesizeOpus() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text, audioFormat: .opus, failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Synthesize text to spoken audio in WAV format. */
    func testSynthesizeWAV() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text, audioFormat: .wav, failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Synthesize text to spoken audio in FLAC format. */
    func testSynthesizeFLAC() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text, audioFormat: .flac, failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Synthesize text to spoken audio in L16 format. */
    func testSynthesizeL16() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text, audioFormat: .l16, failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Retrieve metadata for all custom voice models. */
    func testGetCustomizations() {
        let description = "Get metadata of all custom voices associated with this service instance."
        let expectation = self.expectation(description: description)

        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            XCTAssertEqual(customizations.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Create and delete a custom voice model. */
    func testCreateAndDeleteCustomization() {
        let description1 = "Get all custom voice models and make sure the count is 0."
        let expectation1 = self.expectation(description: description1)

        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            XCTAssertEqual(customizations.count, 0)
            expectation1.fulfill()
        }
        waitForExpectations()

        let description2 = "Create a custom voice model."
        let expectation2 = self.expectation(description: description2)

        var newCVMID: CustomizationID?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID
            expectation2.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description3 = "Get all custom voice models and make sure the count is 1."
        let expectation3 = self.expectation(description: description3)

        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            XCTAssertEqual(customizations.count, 1)
            XCTAssertEqual(customizations.first?.customizationID, customizationID.customizationID)
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the newly created custom voice model."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.deleteCustomization(withID: customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }

    // Temporarily disabled until issue with TTS service is fixed
    /** Create a new custom voice model and update its name. */
    func testCreateUpdateNameAndDeleteCustomVoiceModel() {
        let description1 = "Create a custom voice model."
        let expectation1 = self.expectation(description: description1)

        var newCVMID: CustomizationID?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description2 = "Update the custom voice model's name."
        let expectation2 = self.expectation(description: description2)

        textToSpeech.updateCustomization(
            withID: customizationID.customizationID,
            name: "Updated name",
            failure: failWithError) {

            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Check that the custom voice model's name was updated properly."
        let expectation3 = self.expectation(description: description3)

        textToSpeech.getCustomization(withID: customizationID.customizationID, failure: failWithError) {
            customization in

            XCTAssertEqual(customization.name, "Updated name")
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the newly created custom voice model."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.deleteCustomization(withID: customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }

    // Temporarily disabled until issue with TTS service is fixed
    /** Create a new custom voice model and update its description. */
    func testCreateUpdateDescriptionAndDeleteCustomVoiceModel() {
        let description1 = "Create a custom voice model."
        let expectation1 = self.expectation(description: description1)

        var newCVMID: CustomizationID?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description2 = "Update the custom voice model's description."
        let expectation2 = self.expectation(description: description2)

        textToSpeech.updateCustomization(
            withID: customizationID.customizationID,
            description: "Updated description",
            failure: failWithError) {

                expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Check that the custom voice model's description was updated properly."
        let expectation3 = self.expectation(description: description3)

        textToSpeech.getCustomization(withID: customizationID.customizationID, failure: failWithError) {
            customization in

            XCTAssertEqual(customization.description, "Updated description")
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the newly created custom voice model."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.deleteCustomization(withID: customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }

    /** Create a new custom voice model and update its words list. */
    func testCreateUpdateWordsListAndDeleteCustomVoiceModel() {
        let description1 = "Create a custom voice model."
        let expectation1 = self.expectation(description: description1)

        var newCVMID: CustomizationID?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description2 = "Add a word to the custom voice model."
        let expectation2 = self.expectation(description: description2)

        textToSpeech.updateCustomization(
            withID: customizationID.customizationID,
            words: [Word(word: "IBM", translation: "eye bee em")],
            failure: failWithError) {

                expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Check that the custom voice model's words were updated properly."
        let expectation3 = self.expectation(description: description3)

        textToSpeech.getCustomization(withID: customizationID.customizationID, failure: failWithError) {
            customization in

            XCTAssertEqual(customization.words.count, 1)
            XCTAssertEqual(customization.words.first?.word, "IBM")
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the newly created custom voice model."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.deleteCustomization(withID: customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }

    /** Test adding more than one word to the custom voice model. */
    func testAddMultipleWordsToCustomVoiceModel() {
        let description1 = "Create new custom voice model."
        let expectation1 = self.expectation(description: description1)

        var newCVMID: String?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID.customizationID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description2 = "Add 2 words to the custom voice model."
        let expectation2 = self.expectation(description: description2)

        textToSpeech.addWords(
            toCustomizationID: customizationID,
            fromArray: [
                Word(word: "IBM", translation: "eye bee em"),
                Word(word: "MIL", translation: "mill"),
            ],
            failure: failWithError) {

            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Make sure there are 2 words in the custom voice model."
        let expectation3 = self.expectation(description: description3)

        textToSpeech.getWords(forCustomizationID: customizationID, failure: failWithError) {
            words in

            XCTAssertEqual(words.count, 2)
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the custom voice model."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.deleteCustomization(withID: customizationID) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }

    /** Test adding one word to the custom voice model. */
    func testAddOneWordToCustomVoiceModel() {
        let description1 = "Create new custom voice model."
        let expectation1 = self.expectation(description: description1)

        var newCVMID: String?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID.customizationID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description2 = "Add 1 word to the custom voice model."
        let expectation2 = self.expectation(description: description2)

        textToSpeech.addWord(
            "IBM",
            toCustomizationID: customizationID,
            withTranslation: "eye bee em",
            failure: failWithError) {

            expectation2.fulfill()
        }
        waitForExpectations()

        let description3 = "Make sure there is 1 word in the custom voice model."
        let expectation3 = self.expectation(description: description3)

        textToSpeech.getWords(forCustomizationID: customizationID, failure: failWithError) {
            words in

            XCTAssertEqual(words.count, 1)
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Get the details of the newly added word."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.getTranslation(for: "IBM", withCustomizationID: customizationID, failure: failWithError) {
            translation in

            XCTAssertEqual(translation.translation, "eye bee em")
            expectation4.fulfill()
        }
        waitForExpectations()

        let description5 = "Delete the custom voice model."
        let expectation5 = self.expectation(description: description5)

        textToSpeech.deleteCustomization(withID: customizationID) {
            expectation5.fulfill()
        }
        waitForExpectations()
    }

    /** Test adding and deleting one word to the custom voice model. */
    func testAddAndDeleteOneWordToCustomVoiceModel() {
        let description1 = "Create new custom voice model."
        let expectation1 = self.expectation(description: description1)

        var newCVMID: String?
        textToSpeech.createCustomization(withName: "Swift SDK Test Custom Voice Model", failure: failWithError) {
            customizationID in

            XCTAssertNotNil(customizationID)
            XCTAssertNotEqual(customizationID.customizationID, "")
            newCVMID = customizationID.customizationID
            expectation1.fulfill()
        }
        waitForExpectations()

        guard let customizationID = newCVMID else {
            XCTFail("Failed to create a new custom voice model.")
            return
        }

        let description2 = "Add 1 word to the custom voice model."
        let expectation2 = self.expectation(description: description2)

        textToSpeech.addWord(
            "IBM",
            toCustomizationID: customizationID,
            withTranslation: "eye bee em",
            failure: failWithError) {

                expectation2.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the newly added word."
        let expectation4 = self.expectation(description: description4)

        textToSpeech.deleteWord("IBM", fromCustomizationID: customizationID, failure: failWithError){
            expectation4.fulfill()
        }
        waitForExpectations()

        let description5 = "Make sure there are no words in the custom voice model."
        let expectation5 = self.expectation(description: description5)

        textToSpeech.getWords(forCustomizationID: customizationID, failure: failWithError) {
            words in

            XCTAssertEqual(words.count, 0)
            expectation5.fulfill()
        }
        waitForExpectations()

        let description6 = "Delete the custom voice model."
        let expectation6 = self.expectation(description: description6)

        textToSpeech.deleteCustomization(withID: customizationID) {
            expectation6.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    /** Get the phonetic pronunciation of the given text using an invalid voice type. */
    func testGetPronunciationWithUndefinedVoice() {
        let description = "Get the phonetic pronunciation of the given text."
        let expectation = self.expectation(description: description)

        let voice = "invalid-voice"
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getPronunciation(of: text, voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Retrieve information about an invalid voice. */
    func testGetVoiceInvalid() {
        let description = "Get information about an invalid voice."
        let expectation = self.expectation(description: description)

        let voice = "invalid-voice"
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getVoice(voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Synthesize an empty string. */
    func testSynthesizeEmptyString() {
        let description = "Synthesize an empty string."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.synthesize("", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Synthesize text to spoken audio using an invalid voice. */
    func testSynthesizeWithInvalidVoice() {
        let description = "Synthesize text to spoken audio using an invalid voice."
        let expectation = self.expectation(description: description)

        let voice = "invalid-voice"
        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.synthesize(text, voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Retrieve metadata for all custom voice models when passing an invalid language parameter. */
    func testGetCustomizationsWithInvalidLanguage() {
        let description = "Get all custom voices when passing an invalid value for language parameter."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getCustomizations(language: "InvalidLanguage", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Create custom voice model with invalid language. */
    func testCreateCustomizationWithInvalidLanguage() {
        let description = "Create a custom voice model with an invalid language parameter."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.createCustomization(
            withName: "CustomVoiceModelName",
            language: "InvalidLanguage",
            failure: failure,
            success: failWithResult)

        waitForExpectations()
    }

    /** Delete custom voice model with a bad customization ID. */
    func testDeleteCustomizationWithBadID() {
        let description = "Delete custom voice model without providing a customization ID."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.deleteCustomization(withID: "InvalidIDValue", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Delete custom voice model with a customization ID the user does not have access to. */
    func testDeleteCustomizationWithInaccessibleID() {
        let description = "Delete custom voice model with a customization ID the user can't access."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.deleteCustomization(
            withID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure,
            success: failWithResult)

        waitForExpectations()
    }

    /** Get a custom voice model when providing a bad customization ID. */
    func testGetCustomizationWithBadID() {
        let description = "Get a custom voice model when providing a bad customization ID."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getCustomization(withID: "InvalidIDValue", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Get a custom voice model with a customization ID the user does not have access to. */
    func testGetCustomizationWithInaccessibleID() {
        let description = "Get a custom voice model with a customization ID the user can't access."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getCustomization(
            withID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure,
            success: failWithResult)

        waitForExpectations()
    }

    /** Update a custom voice model when providing a bad customization ID. */
    func testUpdateCustomizationWithBadID() {
        let description = "Update a custom voice model when providing a bad customization ID."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getCustomization(withID: "InvalidIDValue", failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Update a custom voice model with a customization ID the user does not have access to. */
    func testUpdateCustomizationWithInaccessibleID() {
        let description = "Update a custom voice model with a customization ID the user can't access."
        let expectation = self.expectation(description: description)

        let failure = { (error: Error) in
            expectation.fulfill()
        }

        textToSpeech.getCustomization(
            withID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure,
            success: failWithResult)
        waitForExpectations()
    }

    /** Get all words in a custom voice model when providing bad customization IDs. */
    func testGetWordsWithBadIDs() {
        let description1 = "Get all words of a custom voice model when providing a bad customization ID."
        let expectation1 = self.expectation(description: description1)

        let failure1 = { (error: Error) in
            expectation1.fulfill()
        }

        textToSpeech.getWords(forCustomizationID: "InvalidIDValue", failure: failure1, success: failWithResult)
        waitForExpectations()

        let description2 = "Get all words of a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = self.expectation(description: description2)

        let failure2 = { (error: Error) in
            expectation2.fulfill()
        }

        textToSpeech.getWords(
            forCustomizationID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }

    /** Add one or more words to a custom voice model when providing bad customization IDs. */
    func testAddMultipleWordsWithBadIDs() {
        let description1 = "Add words to a custom voice model when providing a bad customization ID."
        let expectation1 = self.expectation(description: description1)

        let failure1 = { (error: Error) in
            expectation1.fulfill()
        }

        textToSpeech.addWords(
            toCustomizationID: "InvalidIDValue",
            fromArray: [Word(word: "ACLs", translation: "ackles")],
            failure: failure1,
            success: failWithResult)
        waitForExpectations()

        let description2 = "Add words to a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = self.expectation(description: description2)

        let failure2 = { (error: Error) in
            expectation2.fulfill()
        }

        textToSpeech.addWords(
            toCustomizationID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            fromArray: [Word(word: "ACLs", translation: "ackles")],
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }

    /** Delete a word from a custom voice model when providing bad customization IDs. */
    func testDeleteWordWithBadIDs() {
        let description1 = "Delete a word from a custom voice model when providing a bad customization ID."
        let expectation1 = self.expectation(description: description1)

        let failure1 = { (error: Error) in
            expectation1.fulfill()
        }

        textToSpeech.deleteWord(
            "someWord",
            fromCustomizationID: "InvalidIDValue",
            failure: failure1,
            success: failWithResult)
        waitForExpectations()

        let description2 = "Delete a word from a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = self.expectation(description: description2)

        let failure2 = { (error: Error) in
            expectation2.fulfill()
        }

        textToSpeech.deleteWord(
            "someWord",
            fromCustomizationID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }

    /** Get a word's translation from a custom voice model when providing bad customization IDs. */
    func testGetWordWithBadIDs() {
        let description1 = "Get a translation from a custom voice model when providing a bad" +
        "customization ID."
        let expectation1 = self.expectation(description: description1)

        let failure1 = { (error: Error) in
            expectation1.fulfill()
        }

        textToSpeech.getTranslation(
            for: "someWord",
            withCustomizationID: "InvalidIDValue",
            failure: failure1,
            success: failWithResult)
        waitForExpectations()

        let description2 = "Get a translation from a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = self.expectation(description: description2)

        let failure2 = { (error: Error) in
            expectation2.fulfill()
        }

        textToSpeech.getTranslation(
            for: "someWord",
            withCustomizationID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }

    /** Add a word to a custom voice model when providing bad customization IDs. */
    func testAddWordWithBadIDs() {
        let description1 = "Add a word to a custom voice model when providing a bad" +
        "customization ID."
        let expectation1 = self.expectation(description: description1)

        let failure1 = { (error: Error) in
            expectation1.fulfill()
        }

        textToSpeech.addWord(
            "someWord",
            toCustomizationID: "InvalidIDValue",
            withTranslation: "translation",
            failure: failure1,
            success: failWithResult)
        waitForExpectations()

        let description2 = "Add a word to a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = self.expectation(description: description2)

        let failure2 = { (error: Error) in
            expectation2.fulfill()
        }

         textToSpeech.addWord(
            "someWord",
            toCustomizationID: "9faad2c9-8602-4c9d-ae20-11696bd16721",
            withTranslation: "translation",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }
}
