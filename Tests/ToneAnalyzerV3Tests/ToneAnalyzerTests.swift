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
import Foundation
import ToneAnalyzerV3

class ToneAnalyzerTests: XCTestCase {

    private var toneAnalyzer: ToneAnalyzer!
    private let timeout: TimeInterval = 5.0
    
    static var allTests : [(String, (ToneAnalyzerTests) -> () throws -> Void)] {
        return [
            ("testGetToneWithDefaultParameters", testGetToneWithDefaultParameters),
            ("testGetToneWithCustomParameters", testGetToneWithCustomParameters),
            ("testGetToneEmptyString", testGetToneEmptyString),
            ("testGetToneInvalidParameters", testGetToneInvalidParameters)
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
        toneAnalyzer = ToneAnalyzer(username: username, password: password, version: "2016-05-10")
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
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    /** Analyze the tone of the given text using the default parameters. */
    func testGetToneWithDefaultParameters() {
        let description = "Analyze the tone of the given text using the default parameters."
        let expectation = self.expectation(description: description)

        toneAnalyzer.getTone(ofText: text, failure: failWithError) { toneAnalysis in
            
            for emotionTone in toneAnalysis.documentTone[0].tones {
                XCTAssertNotNil(emotionTone.name)
                XCTAssertNotNil(emotionTone.id)
                XCTAssert(emotionTone.score <= 1.0 && emotionTone.score >= 0.0)
            }
            
            for writingTone in toneAnalysis.documentTone[1].tones {
                XCTAssertNotNil(writingTone.name)
                XCTAssertNotNil(writingTone.id)
                XCTAssert(writingTone.score <= 1.0 && writingTone.score >= 0.0)
            }
            
            for socialTone in toneAnalysis.documentTone[2].tones {
                XCTAssertNotNil(socialTone.name)
                XCTAssertNotNil(socialTone.id)
                XCTAssert(socialTone.score <= 1.0 && socialTone.score >= 0.0)
            }
            
            guard let sentenceTones = toneAnalysis.sentencesTones else {
                XCTFail("Sentence tones should not be nil.")
                return
            }
            
            for sentence in sentenceTones {
                XCTAssert(sentence.sentenceID >= 0)
                XCTAssertNotEqual(sentence.text, "")
                XCTAssert(sentence.inputFrom >= 0)
                XCTAssert(sentence.inputTo > sentence.inputFrom)
                
                for emotionTone in toneAnalysis.documentTone[0].tones {
                    XCTAssertNotNil(emotionTone.name)
                    XCTAssertNotNil(emotionTone.id)
                    XCTAssert(emotionTone.score <= 1.0 && emotionTone.score >= 0.0)
                }
                
                for writingTone in toneAnalysis.documentTone[1].tones {
                    XCTAssertNotNil(writingTone.name)
                    XCTAssertNotNil(writingTone.id)
                    XCTAssert(writingTone.score <= 1.0 && writingTone.score >= 0.0)
                }
                
                for socialTone in toneAnalysis.documentTone[2].tones {
                    XCTAssertNotNil(socialTone.name)
                    XCTAssertNotNil(socialTone.id)
                    XCTAssert(socialTone.score <= 1.0 && socialTone.score >= 0.0)
                }
            }
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Analyze the tone of the given text with custom parameters. */
    func testGetToneWithCustomParameters() {
        let description = "Analyze the tone of the given text using custom parameters."
        let expectation = self.expectation(description: description)
        
        let tones = ["emotion", "writing"]
        toneAnalyzer.getTone(ofText: text, tones: tones, sentences: false, failure: failWithError) {
            toneAnalysis in
            
            for emotionTone in toneAnalysis.documentTone[0].tones {
                XCTAssertNotNil(emotionTone.name)
                XCTAssertNotNil(emotionTone.id)
                XCTAssert(emotionTone.score <= 1.0 && emotionTone.score >= 0.0)
            }
            
            for writingTone in toneAnalysis.documentTone[1].tones {
                XCTAssertNotNil(writingTone.name)
                XCTAssertNotNil(writingTone.id)
                XCTAssert(writingTone.score <= 1.0 && writingTone.score >= 0.0)
            }
            
            for tone in toneAnalysis.documentTone {
                XCTAssert(tone.name != "Social Tone", "Social tone should not be included")
            }
            
            XCTAssertNil(toneAnalysis.sentencesTones)
            
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    func testGetToneEmptyString() {
        let description = "Analyze the tone of an empty string."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        toneAnalyzer.getTone(ofText: "", failure: failure, success: failWithResult)
        waitForExpectations()
    }
    
    func testGetToneInvalidParameters() {
        let description = "Analyze the tone of the given text using invalid parameters."
        let expectation = self.expectation(description: description)
        
        let failure = { (error: Error) in
            expectation.fulfill()
        }
        
        let tones = ["emotion", "this-tone-is-invalid"]
        toneAnalyzer.getTone(ofText: text, tones: tones, failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
