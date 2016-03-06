/**
 * Copyright IBM Corporation 2015
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
@testable import WatsonDeveloperCloud

class SpeechToTextTests: XCTestCase {

    var service: SpeechToText!
    let timeout: NSTimeInterval = 30.0

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false

        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let credentialsURL = bundle.pathForResource("Credentials", ofType: "plist") else {
            XCTFail("Unable to locate credentials file.")
            return
        }

        // load credentials file
        let dict = NSDictionary(contentsOfFile: credentialsURL)
        guard let credentials = dict as? Dictionary<String, String> else {
            XCTFail("Unable to read credentials file.")
            return
        }

        // read SpeechToText username
        guard let user = credentials["SpeechToTextUsername"] else {
            XCTFail("Unable to read Speech to Text username.")
            return
        }

        // read SpeechToText password
        guard let password = credentials["SpeechToTextPassword"] else {
            XCTFail("Unable to read Speech to Text password.")
            return
        }

        // instantiate the service
        service = SpeechToText(username: user, password: password)
    }

    // Wait for an expectation to be fulfilled.
    func waitForExpectation() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout.")
        }
    }

    // MARK: - Transcribe File, Default Settings

    func testTranscribeFileDefaultWAV() {
        transcribeFileDefault("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func testTranscribeFileDefaultOpus() {
        transcribeFileDefault("SpeechSample", withExtension: "ogg", format: .Opus)
    }

    func testTranscribeFileDefaultFLAC() {
        transcribeFileDefault("SpeechSample", withExtension: "flac", format: .FLAC)
    }

    func transcribeFileDefault(filename: String, withExtension: String, format: AudioMediaType) {
        let description = "Transcribe an audio file."
        let expectation = expectationWithDescription(description)

        let bundle = NSBundle(forClass: self.dynamicType)
        guard let file = bundle.URLForResource(filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        let failure = { (error: NSError) in
            XCTFail("An error occurred: \(error)")
        }

        let settings = SpeechToTextSettings(contentType: format)
        service.transcribe(file, settings: settings, failure: failure) { results in
            for result in results {
                XCTAssert(result.final == true)
                for alternative in result.alternatives {
                    XCTAssertGreaterThan(alternative.transcript.characters.count, 0)
                    XCTAssertGreaterThanOrEqual(alternative.confidence!, 0.0)
                    XCTAssertLessThanOrEqual(alternative.confidence!, 1.0)
                }
            }
            expectation.fulfill()
        }
        waitForExpectation()
    }

    // MARK: - Transcribe Data, Default Settings

    func testTranscribeDataDefaultWAV() {
        transcribeFileDefault("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func testTranscribeDataDefaultOpus() {
        transcribeFileDefault("SpeechSample", withExtension: "ogg", format: .Opus)
    }

    func testTranscribeDataDefaultFLAC() {
        transcribeFileDefault("SpeechSample", withExtension: "flac", format: .FLAC)
    }

    func transcribeDataDefault(filename: String, withExtension: String, format: AudioMediaType) {
        let description = "Transcribe an audio file."
        let expectation = expectationWithDescription(description)

        let bundle = NSBundle(forClass: self.dynamicType)
        guard let file = bundle.URLForResource(filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        guard let audio = NSData(contentsOfURL: file) else {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }

        let failure = { (error: NSError) in
            XCTFail("An error occurred: \(error)")
        }

        let settings = SpeechToTextSettings(contentType: format)
        service.transcribe(audio, settings: settings, failure: failure) { results in
            for result in results {
                XCTAssert(result.final == true)
                for alternative in result.alternatives {
                    XCTAssertGreaterThan(alternative.transcript.characters.count, 0)
                    XCTAssertGreaterThanOrEqual(alternative.confidence!, 0.0)
                    XCTAssertLessThanOrEqual(alternative.confidence!, 1.0)
                }
            }
            expectation.fulfill()
        }
        waitForExpectation()
    }

    // MARK: - Transcribe File, Custom Settings

    func testTranscribeFileCustomWAV() {
        transcribeFileCustom("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func transcribeFileCustom(filename: String, withExtension: String, format: AudioMediaType) {
        let description = "Transcribe an audio file."
        let expectation = expectationWithDescription(description)

        let bundle = NSBundle(forClass: self.dynamicType)
        guard let file = bundle.URLForResource(filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }

        let failure = { (error: NSError) in
            XCTFail("An error occurred: \(error)")
        }

        var settings = SpeechToTextSettings(contentType: format)
        settings.model = "en-US_BroadbandModel" // TODO: Add this back and fix bug.
        settings.learningOptOut = true
        settings.continuous = true
        settings.inactivityTimeout = -1
        settings.keywords = ["tornadoes"]
        settings.keywordsThreshold = 0.75
        settings.maxAlternatives = 3
        settings.interimResults = true
        settings.wordAlternativesThreshold = 0.25
        settings.wordConfidence = true
        settings.timestamps = true
        settings.filterProfanity = false

        service.transcribe(file, settings: settings, failure: failure) { results in
            print(results)

            // TODO: verify results...
            // XCTFail("Need to implement verification.")
            // expectation.fulfill()
        }
        waitForExpectation()
    }

    // MARK: - Validation Functions

    func validateSTTResults(results: [SpeechToTextResult], settings: SpeechToTextSettings) {
        for result in results {
            validateSTTResult(result, settings: settings)
        }
    }

    func validateSTTResult(result: SpeechToTextResult, settings: SpeechToTextSettings) {

        XCTAssertNotNil(result.final)
        XCTAssertNotNil(result.alternatives)

        let final = result.final!

        for alternative in result.alternatives {
            validateSTTTranscription(alternative, final: final, settings: settings)
        }

        if final && settings.keywords?.count > 0 {
            XCTAssertGreaterThanOrEqual(settings.keywordsThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.keywordsThreshold!, 1.0)
            XCTAssertNotNil(result.keywordResults)
            XCTAssertGreaterThan(result.keywordResults!.count, 0)
            for (keyword, keywordResults) in result.keywordResults! {
                validateSTTKeywordResult(keyword, keywordResults: keywordResults)
            }
        }

        if final && settings.wordAlternativesThreshold != nil {
            XCTAssertGreaterThanOrEqual(settings.wordAlternativesThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.wordAlternativesThreshold!, 1.0)
            XCTAssertNotNil(result.wordAlternatives)
            XCTAssertGreaterThan(result.wordAlternatives!.count, 0)
            for word in result.wordAlternatives! {
                validateSTTWordAlternativeResults(word)
            }
        }
    }

    func validateSTTTranscription(
        transcription: SpeechToTextTranscription,
        final: Bool,
        settings: SpeechToTextSettings)
    {
        XCTAssertNotNil(transcription.transcript)
        XCTAssertGreaterThan(transcription.transcript!.characters.count, 0)

        if final {
            XCTAssertNotNil(transcription.confidence)
            XCTAssertGreaterThanOrEqual(transcription.confidence!, 0.0)
            XCTAssertLessThanOrEqual(transcription.confidence!, 1.0)
        } else {
            XCTAssertNil(transcription.confidence)
        }

        if settings.timestamps == true {
            XCTAssertNotNil(transcription.timestamps)
            XCTAssertGreaterThan(transcription.timestamps!.count, 0)
            for timestamp in transcription.timestamps! {
                validateSTTWordTimestamp(timestamp)
            }
        } else {
            XCTAssertNil(transcription.timestamps)
        }

        if final && settings.wordConfidence == true {
            XCTAssertNotNil(transcription.wordConfidence)
            for word in transcription.wordConfidence! {
                validateSTTWordConfidence(word)
            }
        } else {
            // TODO: perhaps this is empty instead of nil when wordConfidence == false?
            XCTAssertNil(transcription.wordConfidence)
        }
    }

    func validateSTTWordTimestamp(timestamp: SpeechToTextWordTimestamp) {
        XCTFail("Needs to be implemented.")
    }

    func validateSTTWordConfidence(word: SpeechToTextWordConfidence) {
        XCTFail("Needs to be implemented.")
    }

    func validateSTTKeywordResult(keyword: String, keywordResults: [SpeechToTextKeywordResult]) {
        XCTFail("Needs to be implemented.")
    }

    func validateSTTWordAlternativeResults(word: SpeechToTextWordAlternativeResults) {
        XCTFail("Needs to be implemented.")
    }

    // TODO: Test a foreign language.
}
