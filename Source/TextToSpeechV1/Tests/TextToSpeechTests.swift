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
import TextToSpeechV1
import AVFoundation

class TextToSpeechTests: XCTestCase {
    
    private var textToSpeech: TextToSpeech!
    private let timeout: NSTimeInterval = 5.0
    private let playAudio = true
    private let text = "Swift at IBM is awesome. You should try it!"
    private let germanText = "Erst denken, dann handeln."
    private let japaneseText = "こんにちは"
    private let ssmlString = "<speak xml:lang=\"En-US\" version=\"1.0\">" +
                             "<say-as interpret-as=\"letters\">Hello</say-as></speak>"
    private let allVoices: [SynthesisVoice] = [
        .DE_Birgit, .DE_Dieter, .GB_Kate, .ES_Enrique, .US_Allison, .US_Lisa, .US_Michael,
        .ES_Laura, .US_Sofia, .FR_Renee, .IT_Francesca, .JP_Emi, .BR_Isabela
    ]
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
        deleteCustomizations()
    }
    
    /** Instantiate Text to Speech instance. */
    func instantiateTextToSpeech() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["TextToSpeechUsername"],
            let password = credentials["TextToSpeechPassword"]
            else {
                XCTFail("Unable to read credentials.")
                return
        }
        textToSpeech = TextToSpeech(username: username, password: password)
    }
    
    /** Delete all customizations. */
    func deleteCustomizations() {
        let description = "Delete all customizations."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            for customization in customizations {
                self.textToSpeech.deleteCustomization(customization.customizationID)
            }
            expectation.fulfill()
        }
        waitForExpectations()
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
    
    /** Retrieve all available voices. */
    func testGetVoices() {
        let description = "Retrieve information about all available voices."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.getVoices(failWithError) { voices in
            XCTAssertGreaterThanOrEqual(voices.count, 8)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Retrieve information about each available voice. */
    func testGetVoice() {
        for voice in allVoices {
            let description = "Get information about the given voice."
            let expectation = expectationWithDescription(description)
            textToSpeech.getVoice(voice, failure: failWithError) { voice in
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }
    
    /** Get the phonetic pronunciation of the given text. */
    func testGetPronunciation() {
        for voice in allVoices {
            let description = "Get the phonetic pronunciation of the given text."
            let expectation = expectationWithDescription(description)
            
            if case .JP_Emi = voice {
                expectation.fulfill()
                continue
            }
            
            textToSpeech.getPronunciation(text, voice: voice, format: .SPR, failure: failWithError) {
                pronunciation in
                XCTAssertGreaterThan(pronunciation.pronunciation.characters.count, 0)
                expectation.fulfill()
            }
            waitForExpectations()
        }
    }
    
    /** Synthesize text to spoken audio using the default parameters. */
    func testSynthesizeDefault() {
        let description = "Synthesize text to spoken audio using the default parameters."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, failure: failWithError) { data in
            XCTAssertGreaterThan(data.length, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using the Lisa voice. */
    func testSynthesizeLisa() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, voice: .US_Lisa, audioFormat: .WAV, failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.length, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using the Dieter voice. */
    func testSynthesizeDieter() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(germanText, voice: .DE_Dieter, audioFormat: .WAV, failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.length, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(2)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using the Emi voice. */
    func testSynthesizeEmi() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(japaneseText, voice: .JP_Emi, audioFormat: .WAV, failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.length, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(2)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio in Opus format. */
    func testSynthesizeOpus() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, audioFormat: .Opus, failure: failWithError) { data in
            XCTAssertGreaterThan(data.length, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio in WAV format. */
    func testSynthesizeWAV() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, audioFormat: .WAV, failure: failWithError) { data in
            XCTAssertGreaterThan(data.length, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio in FLAC format. */
    func testSynthesizeFLAC() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, audioFormat: .FLAC, failure: failWithError) { data in
            XCTAssertGreaterThan(data.length, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio in L16 format. */
    func testSynthesizeL16() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, audioFormat: .L16, failure: failWithError) { data in
            XCTAssertGreaterThan(data.length, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize SSML to spoken audio. */
    func testSynthesizeSSML() {
        let description = "Synthesize SSML to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(ssmlString, failure: failWithError) { data in
            XCTAssertGreaterThan(data.length, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(1)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Retrieve metadata for all custom voice models. */
    func testGetCustomizations() {
        let description = "Get metadata of all custom voices associated with this service instance."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            XCTAssertEqual(customizations.count, 0)
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create and delete a custom voice model. */
    func testCreateAndDeleteCustomization() {
        let description1 = "Get all custom voice models and make sure the count is 0."
        let expectation1 = expectationWithDescription(description1)
        
        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            XCTAssertEqual(customizations.count, 0)
            expectation1.fulfill()
        }
        waitForExpectations()
        
        let description2 = "Create a custom voice model."
        let expectation2 = expectationWithDescription(description2)
        
        var newCVMID: CustomizationID?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation3 = expectationWithDescription(description3)
        
        textToSpeech.getCustomizations(failure: failWithError) { customizations in
            XCTAssertEqual(customizations.count, 1)
            XCTAssertEqual(customizations.first?.customizationID, customizationID.customizationID)
            expectation3.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Delete the newly created custom voice model."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.deleteCustomization(customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create a new custom voice model and update its name. */
    func testCreateUpdateNameAndDeleteCustomVoiceModel() {
        let description1 = "Create a custom voice model."
        let expectation1 = expectationWithDescription(description1)
        
        var newCVMID: CustomizationID?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation2 = expectationWithDescription(description2)
        
        textToSpeech.updateCustomization(
            customizationID.customizationID,
            name: "Updated name",
            failure: failWithError) {
                
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Check that the custom voice model's name was updated properly."
        let expectation3 = expectationWithDescription(description3)
        
        textToSpeech.getCustomization(customizationID.customizationID, failure: failWithError) {
            customization in
            
            XCTAssertEqual(customization.name, "Updated name")
            expectation3.fulfill()
        }
        waitForExpectations()

        let description4 = "Delete the newly created custom voice model."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.deleteCustomization(customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create a new custom voice model and update its description. */
    func testCreateUpdateDescriptionAndDeleteCustomVoiceModel() {
        let description1 = "Create a custom voice model."
        let expectation1 = expectationWithDescription(description1)
        
        var newCVMID: CustomizationID?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation2 = expectationWithDescription(description2)
        
        textToSpeech.updateCustomization(
            customizationID.customizationID,
            description: "Updated description",
            failure: failWithError) {
                
                expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Check that the custom voice model's description was updated properly."
        let expectation3 = expectationWithDescription(description3)
        
        textToSpeech.getCustomization(customizationID.customizationID, failure: failWithError) {
            customization in
            
            XCTAssertEqual(customization.description, "Updated description")
            expectation3.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Delete the newly created custom voice model."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.deleteCustomization(customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Create a new custom voice model and update its words list. */
    func testCreateUpdateWordsListAndDeleteCustomVoiceModel() {
        let description1 = "Create a custom voice model."
        let expectation1 = expectationWithDescription(description1)
        
        var newCVMID: CustomizationID?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation2 = expectationWithDescription(description2)
        
        textToSpeech.updateCustomization(
            customizationID.customizationID,
            words: [Word(word: "IBM", translation: "eye bee em")],
            failure: failWithError) {
                
                expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Check that the custom voice model's words were updated properly."
        let expectation3 = expectationWithDescription(description3)
        
        textToSpeech.getCustomization(customizationID.customizationID, failure: failWithError) {
            customization in
            
            XCTAssertEqual(customization.words.count, 1)
            XCTAssertEqual(customization.words.first?.word, "IBM")
            expectation3.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Delete the newly created custom voice model."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.deleteCustomization(customizationID.customizationID, failure: failWithError) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test adding more than one word to the custom voice model. */
    func testAddMultipleWordsToCustomVoiceModel() {
        let description1 = "Create new custom voice model."
        let expectation1 = expectationWithDescription(description1)
        
        var newCVMID: String?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation2 = expectationWithDescription(description2)
        
        textToSpeech.addWords(
            customizationID,
            words: [Word(word: "IBM",
                translation: "eye bee em"),
                Word(word: "MIL", translation: "mill")],
            failure: failWithError) {
                
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Make sure there are 2 words in the custom voice model."
        let expectation3 = expectationWithDescription(description3)
        
        textToSpeech.getWords(customizationID, failure: failWithError) {
            words in
            
            XCTAssertEqual(words.count, 2)
            expectation3.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Delete the custom voice model."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.deleteCustomization(customizationID) {
            expectation4.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test adding one word to the custom voice model. */
    func testAddOneWordToCustomVoiceModel() {
        let description1 = "Create new custom voice model."
        let expectation1 = expectationWithDescription(description1)
        
        var newCVMID: String?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation2 = expectationWithDescription(description2)
        
        textToSpeech.addWord(
            customizationID,
            word: "IBM",
            translation: "eye bee em",
            failure: failWithError) {
                
            expectation2.fulfill()
        }
        waitForExpectations()
        
        let description3 = "Make sure there is 1 word in the custom voice model."
        let expectation3 = expectationWithDescription(description3)
        
        textToSpeech.getWords(customizationID, failure: failWithError) {
            words in
            
            XCTAssertEqual(words.count, 1)
            expectation3.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Get the details of the newly added word."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.getTranslation(customizationID, word: "IBM", failure: failWithError) {
            translation in
            
            XCTAssertEqual(translation.translation, "eye bee em")
            expectation4.fulfill()
        }
        waitForExpectations()
        
        let description5 = "Delete the custom voice model."
        let expectation5 = expectationWithDescription(description5)
        
        textToSpeech.deleteCustomization(customizationID) {
            expectation5.fulfill()
        }
        waitForExpectations()
    }
    
    /** Test adding and deleting one word to the custom voice model. */
    func testAddAndDeleteOneWordToCustomVoiceModel() {
        let description1 = "Create new custom voice model."
        let expectation1 = expectationWithDescription(description1)
        
        var newCVMID: String?
        textToSpeech.createCustomization("Swift SDK Test Custom Voice Model", failure: failWithError) {
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
        let expectation2 = expectationWithDescription(description2)
        
        textToSpeech.addWord(
            customizationID,
            word: "IBM",
            translation: "eye bee em",
            failure: failWithError) {
                
                expectation2.fulfill()
        }
        waitForExpectations()
        
        let description4 = "Delete the newly added word."
        let expectation4 = expectationWithDescription(description4)
        
        textToSpeech.deleteWord(customizationID, word: "IBM", failure: failWithError){
            expectation4.fulfill()
        }
        waitForExpectations()
        
        let description5 = "Make sure there are no words in the custom voice model."
        let expectation5 = expectationWithDescription(description5)
        
        textToSpeech.getWords(customizationID, failure: failWithError) {
            words in
            
            XCTAssertEqual(words.count, 0)
            expectation5.fulfill()
        }
        waitForExpectations()
        
        let description6 = "Delete the custom voice model."
        let expectation6 = expectationWithDescription(description6)
        
        textToSpeech.deleteCustomization(customizationID) {
            expectation6.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    /** Get the phonetic pronunciation of the given text using an invalid voice type. */
    func testGetPronunciationWithUndefinedVoice() {
        let description = "Get the phonetic pronunciation of the given text."
        let expectation = expectationWithDescription(description)
        
        let voice = SynthesisVoice.Custom(voice: "invalid-voice")
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        textToSpeech.getPronunciation(text, voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }

    /** Retrieve information about an invalid voice. */
    func testGetVoiceInvalid() {
        let description = "Get information about an invalid voice."
        let expectation = expectationWithDescription(description)
        
        let voice = SynthesisVoice.Custom(voice: "invalid-voice")
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        textToSpeech.getVoice(voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Synthesize an empty string. */
    func testSynthesizeEmptyString() {
        let description = "Synthesize an empty string."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        textToSpeech.synthesize("", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using an invalid voice. */
    func testSynthesizeWithInvalidVoice() {
        let description = "Synthesize text to spoken audio using an invalid voice."
        let expectation = expectationWithDescription(description)
        
        let voice = SynthesisVoice.Custom(voice: "invalid-voice")
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 404)
            expectation.fulfill()
        }
        
        textToSpeech.synthesize(text, voice: voice, failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Retrieve metadata for all custom voice models when passing an invalid language parameter. */
    func testGetCustomizationsWithInvalidLanguage() {
        let description = "Get all custom voices when passing an invalid value for language parameter."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        textToSpeech.getCustomizations("InvalidLanguage", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Create custom voice model with invalid language. */
    func testCreateCustomizationWithInvalidLanguage() {
        let description = "Create a custom voice model with an invalid language parameter."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        textToSpeech.createCustomization(
            "CustomVoiceModelName",
            language: "InvalidLanguage",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Delete custom voice model with a bad customization ID. */
    func testDeleteCustomizationWithBadID() {
        let description = "Delete custom voice model without providing a customization ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        textToSpeech.deleteCustomization("InvalidIDValue", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Delete custom voice model with a customization ID the user does not have access to. */
    func testDeleteCustomizationWithInaccessibleID() {
        let description = "Delete custom voice model with a customization ID the user can't access."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation.fulfill()
        }
        
        textToSpeech.deleteCustomization(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Get a custom voice model when providing a bad customization ID. */
    func testGetCustomizationWithBadID() {
        let description = "Get a custom voice model when providing a bad customization ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        textToSpeech.getCustomization("InvalidIDValue", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Get a custom voice model with a customization ID the user does not have access to. */
    func testGetCustomizationWithInaccessibleID() {
        let description = "Get a custom voice model with a customization ID the user can't access."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation.fulfill()
        }
        
        textToSpeech.getCustomization(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure,
            success: failWithResult)
        
        waitForExpectations()
    }
    
    /** Update a custom voice model when providing a bad customization ID. */
    func testUpdateCustomizationWithBadID() {
        let description = "Update a custom voice model when providing a bad customization ID."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }
        
        textToSpeech.getCustomization("InvalidIDValue", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    /** Update a custom voice model with a customization ID the user does not have access to. */
    func testUpdateCustomizationWithInaccessibleID() {
        let description = "Update a custom voice model with a customization ID the user can't access."
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation.fulfill()
        }
        
        textToSpeech.getCustomization(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure,
            success: failWithResult)
        waitForExpectations()
    }
    
    /** Get all words in a custom voice model when providing bad customization IDs. */
    func testGetWordsWithBadIDs() {
        let description1 = "Get all words of a custom voice model when providing a bad customization ID."
        let expectation1 = expectationWithDescription(description1)
        
        let failure1 = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation1.fulfill()
        }
        
        textToSpeech.getWords("InvalidIDValue", failure: failure1, success: failWithResult)
        waitForExpectations()
        
        let description2 = "Get all words of a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = expectationWithDescription(description2)
        
        let failure2 = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation2.fulfill()
        }
        
        textToSpeech.getWords(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }
    
    /** Add one or more words to a custom voice model when providing bad customization IDs. */
    func testAddMultipleWordsWithBadIDs() {
        let description1 = "Add words to a custom voice model when providing a bad customization ID."
        let expectation1 = expectationWithDescription(description1)
        
        let failure1 = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation1.fulfill()
        }
        
        textToSpeech.addWords(
            "InvalidIDValue",
            words: [Word(word: "ACLs", translation: "ackles")],
            failure: failure1,
            success: failWithResult)
        waitForExpectations()
        
        let description2 = "Add words to a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = expectationWithDescription(description2)
        
        let failure2 = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation2.fulfill()
        }
        
        textToSpeech.addWords(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            words: [Word(word: "ACLs", translation: "ackles")],
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }
    
    /** Delete a word from a custom voice model when providing bad customization IDs. */
    func testDeleteWordWithBadIDs() {
        let description1 = "Delete a word from a custom voice model when providing a bad customization ID."
        let expectation1 = expectationWithDescription(description1)
        
        let failure1 = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation1.fulfill()
        }
        
        textToSpeech.deleteWord(
            "InvalidIDValue",
            word: "someWord",
            failure: failure1,
            success: failWithResult)
        waitForExpectations()
        
        let description2 = "Delete a word from a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = expectationWithDescription(description2)
        
        let failure2 = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation2.fulfill()
        }
        
        textToSpeech.deleteWord(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            word: "someWord",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }
    
    /** Get a word's translation from a custom voice model when providing bad customization IDs. */
    func testGetWordWithBadIDs() {
        let description1 = "Get a translation from a custom voice model when providing a bad" +
        "customization ID."
        let expectation1 = expectationWithDescription(description1)
        
        let failure1 = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation1.fulfill()
        }
        
        textToSpeech.getTranslation(
            "InvalidIDValue",
            word: "someWord",
            failure: failure1,
            success: failWithResult)
        waitForExpectations()
        
        let description2 = "Get a translation from a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = expectationWithDescription(description2)
        
        let failure2 = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation2.fulfill()
        }
        
        textToSpeech.getTranslation(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            word: "someWord",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }
    
    /** Add a word to a custom voice model when providing bad customization IDs. */
    func testAddWordWithBadIDs() {
        let description1 = "Add a word to a custom voice model when providing a bad" +
        "customization ID."
        let expectation1 = expectationWithDescription(description1)
        
        let failure1 = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation1.fulfill()
        }
        
        textToSpeech.addWord(
            "InvalidIDValue",
            word: "someWord",
            translation: "translation",
            failure: failure1,
            success: failWithResult)
        waitForExpectations()
        
        let description2 = "Add a word to a custom voice model with a customization ID the " +
        "user can't access."
        let expectation2 = expectationWithDescription(description2)
        
        let failure2 = { (error: NSError) in
            XCTAssertEqual(error.code, 401)
            expectation2.fulfill()
        }
        
         textToSpeech.addWord(
            "9faad2c9-8602-4c9d-ae20-11696bd16721",
            word: "someWord",
            translation: "translation",
            failure: failure2,
            success: failWithResult)
        waitForExpectations()
    }
}
