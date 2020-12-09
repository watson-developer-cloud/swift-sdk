/**
 * (C) Copyright IBM Corp. 2018, 2020.
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
@testable import SpeechToTextV1

class SpeechToTextUnitTests: XCTestCase {

    private var speechToText: SpeechToText!
    private let timeout = 1.0

    private let workspaceID = "test workspace"

    override func setUp() {
        speechToText = SpeechToText(authenticator: defaultTestAuthenticator)
    }

    // MARK: - URLs

    func testWebsocketsURLSetsServiceURL() {
        let apiKey = "your-api-key"
        let speechToTextSession = SpeechToTextSession(authenticator: defaultTestAuthenticator)

        // Default URLs value
        XCTAssertEqual(speechToTextSession.websocketsURL, "wss://api.us-south.speech-to-text.watson.cloud.ibm.com/v1/recognize")
        XCTAssertEqual(speechToTextSession.serviceURL, "https://api.us-south.speech-to-text.watson.cloud.ibm.com")

        // Set websockets URL and verify serviceURL
        speechToTextSession.websocketsURL = "wss://api.au-syd.speech-to-text.watson.cloud.ibm.com/v1/recognize"
        XCTAssertEqual(speechToTextSession.serviceURL, "https://api.au-syd.speech-to-text.watson.cloud.ibm.com")

        // Trailing forward slash
        speechToTextSession.websocketsURL = "wss://api.us-south.speech-to-text.watson.cloud.ibm.com/v1/recognize/"
        XCTAssertEqual(speechToTextSession.serviceURL, "https://api.us-south.speech-to-text.watson.cloud.ibm.com")

        // http instead of https
        speechToTextSession.websocketsURL = "ws://api.us-south.speech-to-text.watson.cloud.ibm.com/v1/recognize"
        XCTAssertEqual(speechToTextSession.serviceURL, "http://api.us-south.speech-to-text.watson.cloud.ibm.com")

        // Different base URL
        speechToTextSession.websocketsURL = "wss://example.com/speech-to-text/api/v1/recognize/v1/recognize"
        XCTAssertEqual(speechToTextSession.serviceURL, "https://example.com/speech-to-text/api")
    }

    // MARK: - Websockets

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
            authenticator: defaultTestAuthenticator,
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
            authenticator: defaultTestAuthenticator,
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
