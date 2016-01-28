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

    func testTranscribeWAV() {
        transcribe("SpeechSample", withExtension: "wav", format: .WAV)
    }

    func transcribe(filename: String, withExtension: String, format: AudioMediaType) {
        let description = "Testing transcribe with pre-recorded file."
        let expectation = expectationWithDescription(description)

        let bundle = NSBundle(forClass: self.dynamicType)
        guard let url = bundle.URLForResource(filename, withExtension: withExtension) else {
            XCTFail("Unable to locate \(filename).\(withExtension).")
            return
        }
        guard let audioData = NSData(contentsOfURL: url) else {
            XCTFail("Unable to read \(filename).\(withExtension).")
            return
        }

        let settings = SpeechToTextSettings(contentType: format)
        service.transcribe(audioData, settings: settings) { responses, error in
            // TODO: verify results...
            expectation.fulfill()
        }
        waitForExpectation()
    }
}
