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
import WatsonDeveloperCloud

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

    func transcribeFileDefault(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
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
            self.validateSTTResults(results, settings: settings)
            XCTAssertEqual(results.count, 1)
            XCTAssert(results.last?.final == true)
            let transcript = results.last?.alternatives.last?.transcript
            XCTAssertNotNil(transcript)
            XCTAssertGreaterThan(transcript!.characters.count, 0)
            expectation.fulfill()
        }
        waitForExpectation()
    }

    // MARK: - Transcribe File, Custom Settings

    func testTranscribeFileCustomWAV() {
        transcribeFileCustom("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func testTranscribeFileCustomOpus() {
        transcribeFileCustom("SpeechSample", withExtension: "ogg", format: .Opus)
    }

    func testTranscribeFileCustomFLAC() {
        transcribeFileCustom("SpeechSample", withExtension: "flac", format: .FLAC)
    }

    func transcribeFileCustom(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
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
        settings.model = "en-US_BroadbandModel"
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
            self.validateSTTResults(results, settings: settings)
            if results.last?.final == true {
                let transcript = results.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.characters.count, 0)
                expectation.fulfill()
            }
        }
        waitForExpectation()
    }

    // MARK: - Transcribe Data, Default Settings

    func testTranscribeDataDefaultWAV() {
        transcribeDataDefault("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func testTranscribeDataDefaultOpus() {
        transcribeDataDefault("SpeechSample", withExtension: "ogg", format: .Opus)
    }

    func testTranscribeDataDefaultFLAC() {
        transcribeDataDefault("SpeechSample", withExtension: "flac", format: .FLAC)
    }

    func transcribeDataDefault(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
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
            self.validateSTTResults(results, settings: settings)
            XCTAssertEqual(results.count, 1)
            XCTAssert(results.last?.final == true)
            let transcript = results.last?.alternatives.last?.transcript
            XCTAssertNotNil(transcript)
            XCTAssertGreaterThan(transcript!.characters.count, 0)
            expectation.fulfill()
        }
        waitForExpectation()
    }

    // MARK: - Transcribe Data, Custom Settings

    func testTranscribeDataCustomWAV() {
        transcribeDataCustom("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func testTranscribeDataCustomOpus() {
        transcribeDataCustom("SpeechSample", withExtension: "ogg", format: .Opus)
    }

    func testTranscribeDataCustomFLAC() {
        transcribeDataCustom("SpeechSample", withExtension: "flac", format: .FLAC)
    }

    func transcribeDataCustom(
        filename: String,
        withExtension: String,
        format: AudioMediaType)
    {
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

        var settings = SpeechToTextSettings(contentType: format)
        settings.model = "en-US_BroadbandModel"
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

        service.transcribe(audio, settings: settings, failure: failure) { results in
            self.validateSTTResults(results, settings: settings)
            if results.last?.final == true {
                let transcript = results.last?.alternatives.last?.transcript
                XCTAssertNotNil(transcript)
                XCTAssertGreaterThan(transcript!.characters.count, 0)
                expectation.fulfill()
            }
        }
        waitForExpectation()
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

    func validateSTTResults(results: [SpeechToTextResult], settings: SpeechToTextSettings) {
        for result in results {
            validateSTTResult(result, settings: settings)
        }
    }

    func validateSTTResult(result: SpeechToTextResult, settings: SpeechToTextSettings) {

        XCTAssertNotNil(result.final)
        let final = result.final!

        XCTAssertNotNil(result.alternatives)
        var alternativesWithConfidence = 0
        for alternative in result.alternatives {
            if alternative.confidence != nil {
                alternativesWithConfidence += 1
                validateSTTTranscription(alternative, best: true, final: final, settings: settings)
            } else {
                validateSTTTranscription(alternative, best: false, final: final, settings: settings)
            }
        }

        if final {
            XCTAssertEqual(alternativesWithConfidence, 1)
        }

        if settings.keywords?.count > 0 && final {
            XCTAssertNotNil(settings.keywordsThreshold)
            XCTAssertGreaterThanOrEqual(settings.keywordsThreshold!, 0.0)
            XCTAssertLessThanOrEqual(settings.keywordsThreshold!, 1.0)
            XCTAssertNotNil(result.keywordResults)
            XCTAssertGreaterThan(result.keywordResults!.count, 0)
            for (keyword, keywordResults) in result.keywordResults! {
                validateSTTKeywordResults(keyword, keywordResults: keywordResults)
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
                validateSTTWordAlternativeResults(wordAlternatives)
            }
        } else {
            let isEmpty = (result.wordAlternatives?.count == 0)
            let isNil = (result.keywordResults == nil)
            XCTAssert(isEmpty || isNil)
        }
    }

    func validateSTTTranscription(
        transcription: SpeechToTextTranscription,
        best: Bool,
        final: Bool,
        settings: SpeechToTextSettings)
    {
        XCTAssertNotNil(transcription.transcript)
        XCTAssertGreaterThan(transcription.transcript!.characters.count, 0)

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
                validateSTTWordTimestamp(timestamp)
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
                validateSTTWordConfidence(word)
            }
        } else {
            let isEmpty = (transcription.wordConfidence?.count == 0)
            let isNil = (transcription.wordConfidence == nil)
            XCTAssert(isEmpty || isNil)
        }
    }

    func validateSTTWordTimestamp(timestamp: SpeechToTextWordTimestamp) {
        XCTAssertGreaterThan(timestamp.word.characters.count, 0)
        XCTAssertGreaterThanOrEqual(timestamp.startTime, 0.0)
        XCTAssertGreaterThanOrEqual(timestamp.endTime, timestamp.startTime)
    }

    func validateSTTWordConfidence(word: SpeechToTextWordConfidence) {
        XCTAssertGreaterThan(word.word.characters.count, 0)
        XCTAssertGreaterThanOrEqual(word.confidence, 0.0)
        XCTAssertLessThanOrEqual(word.confidence, 1.0)
    }

    func validateSTTKeywordResults(keyword: String, keywordResults: [SpeechToTextKeywordResult]) {
        XCTAssertGreaterThan(keyword.characters.count, 0)
        XCTAssertGreaterThan(keywordResults.count, 0)
        for keywordResult in keywordResults {
            validateSTTKeywordResult(keywordResult)
        }
    }

    func validateSTTKeywordResult(keywordResult: SpeechToTextKeywordResult) {
        XCTAssertGreaterThan(keywordResult.normalizedText.characters.count, 0)
        XCTAssertGreaterThanOrEqual(keywordResult.startTime, 0)
        XCTAssertGreaterThanOrEqual(keywordResult.endTime, keywordResult.startTime)
        XCTAssertGreaterThanOrEqual(keywordResult.confidence, 0.0)
        XCTAssertLessThanOrEqual(keywordResult.confidence, 1.0)
    }

    func validateSTTWordAlternativeResults(wordAlternatives: SpeechToTextWordAlternativeResults) {
        XCTAssertGreaterThanOrEqual(wordAlternatives.startTime, 0.0)
        XCTAssertGreaterThanOrEqual(wordAlternatives.endTime, wordAlternatives.startTime)
        XCTAssertGreaterThan(wordAlternatives.alternatives.count, 0)
        for wordAlternative in wordAlternatives.alternatives {
            validateSTTWordAlternativeResult(wordAlternative)
        }
    }

    func validateSTTWordAlternativeResult(wordAlternative: SpeechToTextWordAlternativeResult) {
        XCTAssertGreaterThanOrEqual(wordAlternative.confidence, 0.0)
        XCTAssertLessThanOrEqual(wordAlternative.confidence, 1.0)
        XCTAssertGreaterThan(wordAlternative.word.characters.count, 0)
    }
}
