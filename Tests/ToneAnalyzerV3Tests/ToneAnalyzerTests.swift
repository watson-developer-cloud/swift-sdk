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
import ToneAnalyzerV3

class ToneAnalyzerTests: XCTestCase {

    private var toneAnalyzer: ToneAnalyzer!

    static var allTests: [(String, (ToneAnalyzerTests) -> () throws -> Void)] {
        return [
            ("testGetToneWithDefaultParameters", testGetToneWithDefaultParameters),
            ("testGetToneWithCustomParameters", testGetToneWithCustomParameters),
            ("testGetToneEmptyString", testGetToneEmptyString),
        ]
    }

    let text = "I know the times are difficult! Our sales have been disappointing for " +
               "the past three quarters for our data analytics product suite. We have a " +
               "competitive data analytics product suite in the industry. But we need " +
               "to do our job selling it! "

    // MARK: - Test Configuration

    /** Set up for each test by instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateToneAnalyzer()
    }

    /** Instantiate Tone Analyzer. */
    func instantiateToneAnalyzer() {
        let username = Credentials.ToneAnalyzerUsername
        let password = Credentials.ToneAnalyzerPassword
        toneAnalyzer = ToneAnalyzer(username: username, password: password, version: "2017-09-21")
        toneAnalyzer.defaultHeaders["X-Watson-Learning-Opt-Out"] = "true"
        toneAnalyzer.defaultHeaders["X-Watson-Test"] = "true"
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

    /** Analyze the tone of the given text using the default parameters. */
    func testGetToneWithDefaultParameters() {
        let description = "Analyze the tone of the given text using the default parameters."
        let expectation = self.expectation(description: description)
        toneAnalyzer.tone(toneInput: ToneInput(text: text), contentType: "plain/text", failure: failWithError) {
            toneAnalysis in
            XCTAssertNotNil(toneAnalysis.documentTone.tones)
            XCTAssertGreaterThan(toneAnalysis.documentTone.tones!.count, 0)
            XCTAssertNotNil(toneAnalysis.sentencesTone)
            XCTAssertGreaterThan(toneAnalysis.sentencesTone!.count, 0)
            for sentenceAnalysis in toneAnalysis.sentencesTone! {
                XCTAssertNotNil(sentenceAnalysis.tones)
                XCTAssertGreaterThan(sentenceAnalysis.tones!.count, 0)
                XCTAssertNil(sentenceAnalysis.toneCategories)
                XCTAssertNil(sentenceAnalysis.inputFrom)
                XCTAssertNil(sentenceAnalysis.inputTo)
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }

    /** Analyze the tone of the given text with custom parameters. */
    func testGetToneWithCustomParameters() {
        let description = "Analyze the tone of the given text using custom parameters."
        let expectation = self.expectation(description: description)
        toneAnalyzer.tone(
            toneInput: ToneInput(text: text),
            contentType: "plain/text",
            sentences: false,
            contentLanguage: "en",
            acceptLanguage: "en",
            failure: failWithError)
        {
            toneAnalysis in
            XCTAssertNotNil(toneAnalysis.documentTone.tones)
            XCTAssertGreaterThan(toneAnalysis.documentTone.tones!.count, 0)
            XCTAssertNil(toneAnalysis.sentencesTone)
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests

    func testGetToneEmptyString() {
        let description = "Analyze the tone of an empty string."
        let expectation = self.expectation(description: description)
        let failure = { (error: Error) in expectation.fulfill() }
        toneAnalyzer.tone(
            toneInput: ToneInput(text: ""),
            contentType: "plain/text",
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }
}
