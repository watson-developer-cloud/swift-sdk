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
import ToneAnalyzerV3

class ToneAnalyzerTests: XCTestCase {

    /// Language translation service
    private var service: ToneAnalyzerV3!
    
    /// Timeout for an asynchronous call to return before failing the unit test
    private let timeout: NSTimeInterval = 60.0
    
    let toneText = "I know the times are difficult! Our sales have been disappointing for the past three quarters for our data analytics product suite. We have a competitive data analytics product suite in the industry. But we need to do our job selling it! ";
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).pathForResource("Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: url) as? Dictionary<String, String> {
                let username = dict["ToneAnalyzerUsername"]!
                let password = dict["ToneAnalyzerPassword"]!
                if service == nil {
                    service = ToneAnalyzerV3(username: username, password: password, versionDate: "2016-02-11")
                }
            } else {
                XCTFail("Unable to extract dictionary from plist")
            }
        } else {
            XCTFail("Plist file not found")
        }
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testGetTone() {
        let description = "Analyze the text of Kennedy's speech."
        let expectation = expectationWithDescription(description)

        service.getTone(toneText, failure: failWithError) { tone in
            XCTAssertNotNil(tone, "Tone should not be nil")
            XCTAssertNotNil(tone.documentTone, "DocumentTone should not be nil")
            XCTAssertNotNil(tone.sentencesTones, "SentencesTone should not be nil")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    // MARK: - Negative Tests
    
    func testFetToneNil() {
        let description = "Try to get the tone of an empty string"
        let expectation = expectationWithDescription(description)
        
        let failure = { (error: NSError) in
            XCTAssertEqual(error.localizedFailureReason,
                           "Data could not be serialized. Failed to parse JSON response.")
            expectation.fulfill()
        }
        
        service.getTone("", failure: failure, success: failWithResult)
        waitForExpectations()
    }
}
