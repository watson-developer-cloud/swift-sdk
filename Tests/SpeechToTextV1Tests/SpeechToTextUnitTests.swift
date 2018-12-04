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

    // MARK: - URLs

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

    // MARK - Websockets

    // Check that instantiating a SpeechToTextSession creates the correct SpeechToTextSocket
    func testSpeechToTextSessionSocket() {

        let iamUrl = "https://example.com"
        let model = "testModel"
        let baseModelVersion = "1.0"
        let languageCustomizationID = "123"
        let acousticCustomizationID = "456"
        let learningOptOut = true
        let customerID = "Anthony"

        // API Key authentication
        var sttSession = SpeechToTextSession(
            apiKey: "1234",
            iamUrl: iamUrl,
            model: model,
            baseModelVersion: baseModelVersion,
            languageCustomizationID: languageCustomizationID,
            acousticCustomizationID: acousticCustomizationID,
            learningOptOut: learningOptOut,
            customerID: customerID)

        var socket = sttSession.socket
        var expectedURL = "\(sttSession.websocketsURL)?model=\(model)&base_model_version=\(baseModelVersion)&language_customization_id=\(languageCustomizationID)&acoustic_customization_id=\(acousticCustomizationID)&x-watson-learning-opt-out=\(learningOptOut)&x-watson-metadata=customer_id%3D\(customerID)"
        XCTAssertEqual(socket.url, URL(string: expectedURL))

        // Same as above, but with Basic Auth instead of API Key in the initializer
        sttSession = SpeechToTextSession(
            username: "Anthony",
            password: "hunter2",
            model: model,
            baseModelVersion: baseModelVersion,
            languageCustomizationID: languageCustomizationID,
            acousticCustomizationID: acousticCustomizationID,
            learningOptOut: learningOptOut,
            customerID: customerID)

        socket = sttSession.socket
        expectedURL = "\(sttSession.websocketsURL)?model=\(model)&base_model_version=\(baseModelVersion)&language_customization_id=\(languageCustomizationID)&acoustic_customization_id=\(acousticCustomizationID)&x-watson-learning-opt-out=\(learningOptOut)&x-watson-metadata=customer_id%3D\(customerID)"
        XCTAssertEqual(socket.url, URL(string: expectedURL))
    }
}
