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
    private let timeout: NSTimeInterval = 30.0
    private let playAudio = true
    private let text = "Swift at IBM is awesome. You should try it!"
    private let germanText = "Erst denken, dann handeln."
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
            textToSpeech.getPronunciation(text, voice: voice, format: .SPR, failure: failWithError) {
                pronunciation in
                if case .JP_Emi = voice {
                    expectation.fulfill()
                } else {
                    XCTAssertGreaterThan(pronunciation.pronunciation.characters.count, 0)
                    expectation.fulfill()
                }
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
    
    /** Synthesize text to spoken audio in OGG format. */
    func testSynthesizeOGG() {
        let description = "Synthesize text to spoken audio."
        let expectation = expectationWithDescription(description)
        
        textToSpeech.synthesize(text, audioFormat: .OGG, failure: failWithError) { data in
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
}
