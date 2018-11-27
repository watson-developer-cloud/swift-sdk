/**
 * Copyright IBM Corporation 2018
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
import RestKit
@testable import SpeechToTextV1

class SpeechToTextUnitTests: XCTestCase {

    private var speechToText: SpeechToText!
    private let timeout = 1.0

    private let workspaceID = "test workspace"

    override func setUp() {
        speechToText = SpeechToText(accessToken: accessToken)
    }

    func testServiceURLSetsWebsocketsURL() {
        speechToText.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
        XCTAssertEqual(speechToText.websocketsURL, "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize")

        // Trailing forward slash
        speechToText.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api/"
        XCTAssertEqual(speechToText.serviceURL, "https://stream.watsonplatform.net/speech-to-text/api")
        XCTAssertEqual(speechToText.websocketsURL, "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize")

        // http instead of https
        speechToText.serviceURL = "http://stream.watsonplatform.net/speech-to-text/api"
        XCTAssertEqual(speechToText.websocketsURL, "ws://stream.watsonplatform.net/speech-to-text/api/v1/recognize")

        // Different base URL
        speechToText.serviceURL = "https://example.com/speech-to-text/api"
        XCTAssertEqual(speechToText.websocketsURL, "wss://example.com/speech-to-text/api/v1/recognize")
    }

    func testServiceURLSetsTokenURL() {
        speechToText.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
        XCTAssertEqual(speechToText.tokenURL, "https://stream.watsonplatform.net/authorization/api/v1/token")

        // http instead of https
        speechToText.serviceURL = "http://stream.watsonplatform.net/speech-to-text/api"
        XCTAssertEqual(speechToText.tokenURL, "http://stream.watsonplatform.net/authorization/api/v1/token")

        // Different base URL
        speechToText.serviceURL = "https://example.com/speech-to-text/api"
        XCTAssertEqual(speechToText.tokenURL, "https://example.com/authorization/api/v1/token")
    }
}
