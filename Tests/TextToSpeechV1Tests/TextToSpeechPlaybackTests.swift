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

#if !os(Linux)
import XCTest
import TextToSpeechV1
import AVFoundation

class TextToSpeechPlaybackTests: XCTestCase {

    private var textToSpeech: TextToSpeech!
    private let playAudio = true
    private let text = "Swift at IBM is awesome. You should try it!"
    private let germanText = "Erst denken, dann handeln."
    private let japaneseText = "こんにちは"
    private let ssmlString = "<speak xml:lang=\"En-US\" version=\"1.0\">" +
    "<say-as interpret-as=\"letters\">Hello</say-as></speak>"

    // MARK: - Test Configuration

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
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

    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Wait for expectations. */
    func waitForExpectations(timeout: TimeInterval = 10.0) {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }

    // MARK: - Positive Tests

    /** Synthesize text to spoken audio using the default parameters. */
    func testSynthesizeDefault() {
        let description = "Synthesize text to spoken audio using the default parameters."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: text, accept: "audio/wav", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
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
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: text, accept: "audio/wav", voice: "en-US_LisaVoice", failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.count, 0)
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
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: germanText, accept: "audio/wav", voice: "de-DE_DieterVoice", failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.count, 0)
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
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: japaneseText, accept: "audio/wav", voice: "ja-JP_EmiVoice", failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.count, 0)
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

    /** Synthesize SSML to spoken audio. */
    func testSynthesizeSSML() {
        let description = "Synthesize SSML to spoken audio."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: ssmlString, accept: "audio/wav", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
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

    // This test works when you run it individually, but for some reason, running it after the
    // testSynthesizeFlac() method causes this one to fail. The audio types aren't updated somehow,
    // and the service seems to think we are still requesting .flac instead of .opus.
    /** Synthesize text to spoken audio in Opus format. */
    func testSynthesizeOpus() {
        let description = "Synthesize text to spoken audio in Opus format."
        let expectation = self.expectation(description: description)

        textToSpeech.synthesize(text: text, accept: "audio/ogg;codecs=opus", failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail("Failed to create audio player.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
#endif
